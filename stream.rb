require 'aws-sdk-dynamodbstreams'

client = Aws::DynamoDBStreams::Client.new

resp = client.describe_stream({ stream_arn: ARGV[0] })

shards = {}
resp.stream_description.shards.map { |shard| shards[shard.shard_id] = shard.parent_shard_id }

shards.each { |shard, parent| p 1 unless shards.key?(parent) }

1/0

resp = client.get_shard_iterator(
  {
    shard_id: 'shardId-00000001600246907471-9ce0b613',
    # shard_id: 'shardId-00000001600246907779-7cedea21',
    # shard_id: 'shardId-00000001600246907676-418d54b1',
    # shard_id: 'shardId-00000001600246907779-7cedea21',
    shard_iterator_type: 'TRIM_HORIZON',
    stream_arn: ARGV[0]
  }
)
p resp.shard_iterator

next_shard_iterator = resp.shard_iterator

while true
  resp = client.get_records({ shard_iterator: next_shard_iterator })
  p resp.records
  next_shard_iterator = resp.next_shard_iterator
  sleep 1
end