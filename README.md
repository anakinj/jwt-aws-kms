# JWT::KMS

AWS KMS algorithm extensions for ruby-jwt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jwt-kms'
```

And require the gem in your code.

```ruby
require `jwt/kms`
```

## Usage

```ruby

# Create a key, for example with the ruby AWS SDK
key = Aws::KMS::Client.new.create_key(key_spec: "HMAC_512", key_usage: "GENERATE_VERIFY_MAC")

algo = ::JWT::KMS.by/key_id: key.key_metadata.key_id )

token = JWT.encode(payload, nil, algo)
decoded_token = JWT.decode(token, "Not relevant", true, algorithm: algo)
```


## Development

```
docker run \
  --rm -it \
  -p 127.0.0.1:4566:4566 \
  -p 127.0.0.1:4510-4559:4510-4559 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  localstack/localstack
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anakinj/jwt-kms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/anakinj/jwt-kms/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jwt::Kms project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/anakinj/jwt-kms/blob/main/CODE_OF_CONDUCT.md).
