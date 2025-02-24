<?php
/**
 * ZanCms
 * ============================================================================
 * 版权所有 2020-2035 海南赞赞网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.zancms.com
 * ----------------------------------------------------------------------------
 * 如果商业用途务必到官方购买正版授权, 以免引起不必要的法律纠纷.
 * ============================================================================
 * Author: 小虎哥 <1105415366@qq.com>
 * Date: 2018-06-28
 */

namespace app\api\controller;

use think\Db;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;

/**
 * 翻译API管理
 */
class TranslateApi extends Base
{
    /**
     * 构造方法
     */
    public function __construct()
    {
        parent::__construct();

        // 豆包翻译API配置
        $this->doubao = tpSetting('doubao');
    }

    public function translate()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (empty($post['lang'])) $this->error('没有要翻译的语言');
            if (empty($post['content'])) $this->error('请输入内容再进行翻译');

            $postLang = trim($post['lang']);
            if ('cn' === trim($post['lang'])) {
                $postLang = 'zh';
            } else if ('zh' === trim($post['lang'])) {
                $postLang = 'zh-Hant';
            }

            // 请求内容
            $body = [
                'TargetLanguage' => trim($postLang),
                'TextList' => [$post['content']],
            ];
            $body = json_encode($body);

            $query = [
                'Action' => 'TranslateText',
                'Version' => '2020-06-01'
            ];
            ksort($query);
            $requestParam = [
                'body' => $body,
                'host' => 'translate.volcengineapi.com',
                'path' => '/',
                'method' => 'POST',
                'contentType' => 'application/json',
                'date' => gmdate('Ymd\THis\Z'),
                'query' => $query
            ];

            $xDate = $requestParam['date'];
            $xContentSha256 = hash('sha256', $requestParam['body']);
            $signResult = [
                'Host' => $requestParam['host'],
                'X-Content-Sha256' => $xContentSha256,
                'X-Date' => $xDate,
                'Content-Type' => $requestParam['contentType']
            ];

            $credential = [
                'accessKeyId' => $this->doubao['doubao_access_key_id'],
                'secretKeyId' => $this->doubao['doubao_secret_access_key'],
                'service' => 'translate',
                'region' => 'cn-north-1',
            ];
            $signedHeaderStr = join(';', ['content-type', 'host', 'x-content-sha256', 'x-date']);
            $canonicalRequestStr = join("\n", [
                $requestParam['method'],
                $requestParam['path'],
                http_build_query($requestParam['query']),
                join("\n", ['content-type:' . $requestParam['contentType'], 'host:' . $requestParam['host'], 'x-content-sha256:' . $signResult['X-Content-Sha256'], 'x-date:' . $requestParam['date']]),
                '',
                $signedHeaderStr,
                $signResult['X-Content-Sha256']
            ]);
            $shortXDate = substr($requestParam['date'], 0, 8);
            $hashedCanonicalRequest = hash("sha256", $canonicalRequestStr);
            $credentialScope = join('/', [$shortXDate, $credential['region'], $credential['service'], 'request']);
            $stringToSign = join("\n", ['HMAC-SHA256', $requestParam['date'], $credentialScope, $hashedCanonicalRequest]);
            $kDate = hash_hmac("sha256", $shortXDate, $credential['secretKeyId'], true);
            $kRegion = hash_hmac("sha256", $credential['region'], $kDate, true);
            $kService = hash_hmac("sha256", $credential['service'], $kRegion, true);
            $kSigning = hash_hmac("sha256", 'request', $kService, true);
            $signature = hash_hmac("sha256", $stringToSign, $kSigning);
            $signResult['Authorization'] = sprintf("HMAC-SHA256 Credential=%s, SignedHeaders=%s, Signature=%s", $credential['accessKeyId'] . '/' . $credentialScope, $signedHeaderStr, $signature);

            // 加载client
            $clientObj = new Client(['base_uri' => 'http://' . $requestParam['host'], 'timeout' => 120.0]);
            // 调接翻译接口
            $clientData = [
                'headers' => $signResult,
                'query' => $requestParam['query'],
                'body' => $requestParam['body']
            ];
            $resultObj = $clientObj->request($requestParam['method'], 'http://' . $requestParam['host'] . $requestParam['path'], $clientData);
            // 解析数据
            $resultArr = $resultObj->getBody()->getContents();
            $resultArr = !empty($resultArr) ? json_decode($resultArr, true) : [];

            if (empty($resultArr)) $this->success('翻译失败', null, ['code' => 0, 'msg' => '翻译内容存在异常，请再次翻译该语言内容']);
            if (!empty($resultArr['ResponseMetaData']['Error'])) {
                $msg = '火山引擎接口提示: ' . $resultArr['ResponseMetaData']['Error']['Message'];
                if ('-400' == strval($resultArr['ResponseMetaData']['Error']['Code'])) {
                    $msg = '火山引擎接口提示: 详情信息字数超过限制(仅支持5k字符翻译)，请简短内容再次翻译该语言内容';
                }
                else if ('-415' == strval($resultArr['ResponseMetaData']['Error']['Code'])) {
                    $msg = '火山引擎接口提示: 暂不支持该语言翻译';
                }
                else if ('-429' == strval($resultArr['ResponseMetaData']['Error']['Code'])) {
                    $msg = '火山引擎接口提示: 当前语言请求过于频繁，请稍后再次翻译该语言内容';
                }
                else if ('-500' == strval($resultArr['ResponseMetaData']['Error']['Code'])) {
                    $msg = '火山引擎接口提示: 当前翻译服务内部错误，请稍后再次翻译该语言内容';
                }
                $this->success('翻译失败', null, ['code' => 0, 'msg' => $msg]);
            }
            else if (!empty($resultArr['ResponseMetadata']['Error'])) {
                $msg = '火山引擎接口提示: ' . $resultArr['ResponseMetadata']['Error']['Code'];
                if (100009 === intval($resultArr['ResponseMetadata']['Error']['CodeN'])) {
                    $msg = '火山引擎接口提示: 请求的Access Key ID错误。 请检查本系统的[设置]-[翻译设置]-[Access Key ID]是否填写正确，注意不要有多余的空格符号';
                }
                else if (100010 === intval($resultArr['ResponseMetadata']['Error']['CodeN'])) {
                    $msg = '火山引擎接口提示: 请求的Secret Access Key错误。 请检查本系统的[设置]-[翻译设置]-[Secret Access Key]是否填写正确，注意不要有多余的空格符号';
                }
                $this->error($msg);
            }

            // 延迟1秒返回
            // sleep(1);
            if (!empty($resultArr['TranslationList'][0]['Translation'])) {
                $this->success('翻译成功', null, htmlspecialchars_decode($resultArr['TranslationList'][0]['Translation']));
            } else {
                $this->error('翻译失败');
            }
        }
    }
}