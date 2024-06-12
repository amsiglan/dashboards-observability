CREATE MATERIALIZED VIEW {table_name}__live_mview_2 AS
  SELECT
    CAST(IFNULL(`src_endpoint.port`, 0) AS LONG) AS `aws.vpc.srcport`,
    CAST(IFNULL(`src_endpoint.ip`, 'Unknown') AS STRING)  AS `aws.vpc.pkt-src-aws-service`,
    CAST(IFNULL(`src_endpoint.ip`, '0.0.0.0') AS STRING)  AS `aws.vpc.srcaddr`,
    CAST(IFNULL(`src_endpoint.interface_uid`, 'Unknown') AS STRING)  AS `aws.vpc.src-interface_uid`,
    CAST(IFNULL(src_endpoint.vpc_uid, 'Unknown') AS STRING)  AS `aws.vpc.src-vpc_uid`,
    CAST(IFNULL(src_endpoint.instance_uid, 'Unknown') AS STRING)  AS `aws.vpc.src-instance_uid`,
    CAST(IFNULL(src_endpoint.subnet_uid, 'Unknown') AS STRING)  AS `aws.vpc.src-subnet_uid`,
    CAST(IFNULL(dst_endpoint.port, 0) AS LONG) AS `aws.vpc.dstport`,
    CAST(IFNULL(dst_endpoint.ip, 'Unknown') AS STRING) AS `aws.vpc.pkt-dst-aws-service`,
    CAST(IFNULL(dst_endpoint.ip, '0.0.0.0') AS STRING)  AS `aws.vpc.dstaddr`,
    CAST(IFNULL(connection_info.direction, 'Unknown') AS STRING) AS `aws.vpc.flow-direction`,
    CAST(IFNULL(connection_info.tcp_flags, '0') AS STRING)  AS `aws.vpc.connection.tcp_flags`,
    CAST(IFNULL(traffic.packets, 0) AS LONG) AS `aws.vpc.packets`,
    CAST(IFNULL(traffic.bytes, 0) AS LONG) AS `aws.vpc.bytes`,
    CAST(start_time_dt AS TIMESTAMP) AS `@timestamp`,
    CAST(start_time_dt AS TIMESTAMP) AS `start_time`,
    CAST(start_time_dt AS TIMESTAMP) AS `interval_start_time`,
    CAST(end_time_dt AS TIMESTAMP) AS `end_time`,
    CAST(IFNULL(status_code, 'Unknown') AS STRING)  AS `aws.vpc.status_code`,
    CAST(IFNULL(metadata.product.version, 0) AS LONG) AS `aws.vpc.version`,
    CAST(IFNULL(connection_info.protocol_ver, 'Unknown') AS STRING)  AS `aws.vpc.type_name`,
    CAST(IFNULL(connection_info.boundary_id, 0) AS LONG)  AS `aws.vpc.traffic_path`,
    CAST(IFNULL(cloud.zone, 'Unknown') AS STRING) AS `aws.vpc.az_id`,
    CAST(IFNULL(activity_name, 'Unknown') AS STRING) AS `aws.vpc.action`,
    CAST(IFNULL(cloud.region, 'Unknown') AS STRING) AS `aws.vpc.region`,
    CAST(IFNULL(cloud.account.uid, 'Unknown') AS STRING) AS `aws.vpc.account-id`,
    CAST(IFNULL(unmapped['sublocation_type'], 'Unknown') AS STRING) AS `aws.vpc.sublocation_type`,
    CAST(IFNULL(unmapped['sublocation_id'], 'Unknown') AS STRING) AS `aws.vpc.sublocation_id`

  FROM
    {table_name}
WITH (
  auto_refresh = true,
  refresh_interval = '15 Minute',
  checkpoint_location = '{s3_checkpoint_location}',
  watermark_delay = '1 Minute',
  extra_options = '{ "{table_name}": { "maxFilesPerTrigger": "10" }}'
)
