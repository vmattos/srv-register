AWS = require 'aws-sdk'

config =
  hostedZoneId: process.env.HOSTED_ZONE_ID or "Z2BTHNR77B30V7"
  recordSetName: process.env.RECORD_SET_NAME or  "_etcd-server._tcp.vtexlab.com.br."
  placeholder: process.env.RECORD_SET_PLACEHOLDER or "1 10 7001 placeholder.example.com"
  registerPort: process.env.PROCESS_PORT or "7001"
  ip: process.env.NODE_IP

route53 = new AWS.Route53()

getParams =
    HostedZoneId: config.hostedZoneId
    StartRecordName: config.recordSetName

route53.listResourceRecordSets getParams, (err, data) ->
  return console.error(err) if err
  rr = data.ResourceRecordSets[0]
  console.log rr.ResourceRecords

  rr.ResourceRecords.forEach (item, i) ->
    if item.Value is config.placeholder
      rr.ResourceRecords.splice(i, 1)

  newRR =
    Value: "1 10 #{config.registerPort} " + config.ip

  rr.ResourceRecords.push(newRR)

  params =
    HostedZoneId: config.hostedZoneId
    ChangeBatch:
      Changes: [
        {
          Action: 'UPSERT'
          ResourceRecordSet:
            Name:config.recordSetName
            Type: 'SRV'
            TTL: 0
            ResourceRecords: rr.ResourceRecords
        }
      ]

  route53.changeResourceRecordSets params, (err, data) ->
    console.error err if err
