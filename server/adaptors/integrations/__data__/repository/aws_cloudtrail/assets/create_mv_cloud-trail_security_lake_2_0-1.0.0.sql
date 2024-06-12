CREATE MATERIALIZED VIEW {table_name}__mview AS
SELECT
   CAST(IFNULL(actor.user.type, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.type`,
   CAST(IFNULL(actor.user.uid_alt, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.principalId`,
   CAST(IFNULL(actor.user.uid, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.arn`,
   CAST(IFNULL(actor.user.account.uid, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.accountId`,
   CAST(IFNULL(actor.invoked_by, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.invokedBy`,
   CAST(IFNULL(actor.user.credential_uid, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.accessKeyId`,
   CAST(IFNULL(actor.user.name, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.userName`,
   CAST(IFNULL(actor.session.is_mfa, false) AS BOOLEAN) AS `aws.cloudtrail.userIdentity.sessionContext.attributes.mfaAuthenticated`,
   CAST( actor.session.created_time_dt  AS TIMESTAMP) AS `aws.cloudtrail.userIdentity.sessionContext.attributes.creationDate`,
   CAST(IFNULL(unmapped['userIdentity.sessionContext.sessionIssuer.type'], 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.sessionContext.sessionIssuer.type`,
   CAST(IFNULL(unmapped['userIdentity.sessionContext.sessionIssuer.principalId'], 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.sessionContext.sessionIssuer.principalId`,
   CAST(IFNULL(actor.session.issuer, 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.sessionContext.sessionIssuer.arn`,
   CAST(IFNULL(unmapped['userIdentity.sessionContext.sessionIssuer.accountId'], 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.sessionContext.sessionIssuer.accountId`,
   CAST(IFNULL(unmapped['userIdentity.sessionContext.sessionIssuer.userName'], 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.sessionContext.sessionIssuer.userName`,
   CAST(IFNULL(unmapped['userIdentity.sessionContext.ec2RoleDelivery'], 'Unknown') AS STRING) AS `aws.cloudtrail.userIdentity.sessionContext.ec2RoleDelivery`,

   CAST(IFNULL(metadata.product.version, 'Unknown') AS STRING) AS `aws.cloudtrail.eventVersion`,
   CAST( time AS TIMESTAMP)  AS `@timestamp`,
   CAST(IFNULL(api.service.name, 'Unknown') AS STRING) AS `aws.cloudtrail.eventSource`,
   CAST(IFNULL(api.operation, 'Unknown') AS STRING) AS `aws.cloudtrail.eventName`,
   CAST(IFNULL(metadata.product.feature.name, 'Unknown') AS STRING) AS `aws.cloudtrail.eventCategory`,
   CAST(IFNULL(metadata.event_code, 'Unknown') AS STRING) AS `aws.cloudtrail.eventType`,
   CAST(IFNULL(metadata.uid, 'Unknown') AS STRING) AS `aws.cloudtrail.eventId`,

   CAST(IFNULL(cloud.region, 'Unknown') AS STRING) AS `aws.cloudtrail.awsRegion`,
   CAST(IFNULL(src_endpoint.ip, '0.0.0.0') AS STRING) AS `aws.cloudtrail.sourceIPAddress`,
   CAST(IFNULL(http_request.user_agent, 'Unknown') AS STRING) AS `aws.cloudtrail.userAgent`,
   CAST(IFNULL(api.response.error, 'Unknown') AS STRING) AS `errorCode`,
   CAST(IFNULL(api.response.message, 'Unknown') AS STRING) AS `errorMessage`,
   CAST(IFNULL(api.request.data, 'Unknown') AS STRING) AS `aws.cloudtrail.requestParameter`,
   CAST(IFNULL(api.response.data, 'Unknown') AS STRING) AS `aws.cloudtrail.responseElements`,
   CAST(IFNULL(dst_endpoint.svc_name, 'Unknown') AS STRING) AS `aws.cloudtrail.additionalEventData`,
   CAST(IFNULL(api.request.uid, 'Unknown') AS STRING) AS `aws.cloudtrail.requestId`,
   resources AS `aws.cloudtrail.resources`,
   CAST(IFNULL(api.version, 'Unknown') AS STRING) AS `aws.cloudtrail.apiVersion`,
   CAST(IFNULL(unmapped['readOnly'], 'Unknown') AS STRING) AS `aws.cloudtrail.readOnly`,
   CAST(IFNULL(unmapped['recipientAccountId'], 0) AS LONG) AS `aws.cloudtrail.recipientAccountId`,
   CAST(IFNULL(unmapped['sharedEventId'], 'Unknown') AS STRING) AS `aws.cloudtrail.sharedEventId`,
   CAST(IFNULL(src_endpoint.uid, 'Unknown') AS STRING) AS `aws.cloudtrail.vpcEndpointId`,
   CAST(IFNULL(unmapped['tlsDetails.tlsVersion'], 'Unknown') AS STRING) AS `aws.cloudtrail.tlsDetails.tls_version`,
   CAST(IFNULL(unmapped['tlsDetails.cipherSuite'], 'Unknown') AS STRING) AS `aws.cloudtrail.tlsDetailscipher_suite`,
   CAST(IFNULL(unmapped['tlsDetails.clientProvidedHostHeader'], 'Unknown') AS STRING) AS `aws.cloudtrail.tlsDetailsclient_provided_host_header`
FROM
  {table_name}
WITH (
    auto_refresh = true,
    refresh_interval = '15 Minute',
    checkpoint_location = '{s3_checkpoint_location}',
    watermark_delay = '1 Minute',
    extra_options = '{ "{table_name}": { "maxFilesPerTrigger": "10" }}'
)
