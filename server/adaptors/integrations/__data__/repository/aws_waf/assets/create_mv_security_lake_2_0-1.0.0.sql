CREATE MATERIALIZED VIEW {table_name}__mview AS
SELECT
    CAST(FROM_UNIXTIME(`time`/ 1000) AS TIMESTAMP) AS `@timestamp`,
    CAST(IFNULL(`metadata.product.version`, 'Unknown') AS STRING) AS `aws.waf.formatVersion`,
    CAST(IFNULL(`metadata.product.feature.uid`, 'Unknown') AS STRING) AS `aws.waf.webaclId`,
    CAST(IFNULL(`firewall_rule.uid`, 'Unknown') AS STRING) AS `aws.waf.terminatingRuleId`,
    CAST(IFNULL(`firewall_rule.type`, 'Unknown') AS STRING) AS `aws.waf.terminatingRuleType`,
    CAST(IFNULL(action, 'Unknown') AS STRING) AS `aws.waf.action`,
    CAST(IFNULL(`src_endpoint.svc_name`, 'Unknown') AS STRING) AS `aws.waf.httpSourceName`,
    CAST(IFNULL(`src_endpoint.uid`, 'Unknown') AS STRING) AS `aws.waf.httpSourceId`,
    ruleGroupList AS `aws.waf.ruleGroupList`,
    unmapped['rateBasedRuleList'] AS `aws.waf.rateBasedRuleList`,
    nonTerminatingMatchingRules AS `aws.waf.nonTerminatingMatchingRules`,
    CAST(IFNULL(`http_status`, 0) AS LONG) AS `aws.waf.responseCodeSent`,
    httpRequest AS `aws.waf.httpRequest`,
    metadata.labels AS `aws.waf.labels`,
    unmapped['captchaResponse'] AS `aws.waf.captchaResponse`
FROM
    {table_name}
WITH (
  auto_refresh = true,
  refresh_interval = '15 Minute',
  checkpoint_location = '{s3_checkpoint_location}',
  watermark_delay = '1 Minute',
  extra_options = '{ "{table_name}": { "maxFilesPerTrigger": "10" }}'
)
