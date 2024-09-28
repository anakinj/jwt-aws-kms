# JWT::Aws::KMS

AWS KMS algorithm extensions for ruby-jwt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jwt-aws-kms'
```

And require the gem in your code.

```ruby
require `jwt-aws-kms`
```
## Supported algorithms

The gem supports the following AWS KMS algorithms:

| Algorithm Name | Description                                      | JWA Name |
|----------------|--------------------------------------------------|-------------------------|
| RSASSA_PKCS1_V1_5_SHA_256 | RSASSA PKCS1 v1.5 using SHA-256       | RS256                   |
| RSASSA_PKCS1_V1_5_SHA_384 | RSASSA PKCS1 v1.5 using SHA-384       | RS384                   |
| RSASSA_PKCS1_V1_5_SHA_512 | RSASSA PKCS1 v1.5 using SHA-512       | RS512                   |
| RSASSA_PSS_SHA_256 | RSASSA PSS using SHA-256                     | PS256                   |
| RSASSA_PSS_SHA_384 | RSASSA PSS using SHA-384                     | PS384                   |
| RSASSA_PSS_SHA_512 | RSASSA PSS using SHA-512                     | PS512                   |
| ECDSA_SHA_256 | ECDSA using P-256 and SHA-256                     | ES256                   |
| ECDSA_SHA_384 | ECDSA using P-384 and SHA-384                     | ES384                   |
| ECDSA_SHA_512 | ECDSA using P-521 and SHA-512                     | ES512                   |

## Usage

### Basic usage
```ruby

# Create a key, for example with the ruby AWS SDK
key = Aws::KMS::Client.new.create_key(key_spec: "HMAC_512", key_usage: "GENERATE_VERIFY_MAC")

algo = ::JWT::Aws::KMS.for(algorithm: "HS512")

token = JWT.encode(payload, key.key_metadata.key_id, algo)
decoded_token = JWT.decode(token, key.key_metadata.key_id, true, algorithm: algo)
```
### Replace default algorithms

You can swap the default algorithms in the JWT gem to AWS backed ones by calling `::JWT::Aws::KMS.replace_defaults!`.

```ruby
   ::JWT::Aws::KMS.replace_defaults! # Called in a initializer of some kind

  token = JWT.encode(payload, "e25c502b-a383-44ac-a778-0d97e8688cb7", "HS512") # Encode payload with KMS key e25c502b-a383-44ac-a778-0d97e8688cb7
```

## Development

[Localstack](https://www.localstack.cloud/) can be used to simulate the AWS KMS environment.

```
docker run \
  --rm -it \
  -p 127.0.0.1:4566:4566 \
  -p 127.0.0.1:4510-4559:4510-4559 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  localstack/localstack
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anakinj/jwt-aws-kms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/anakinj/jwt-aws-kms/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jwt::Kms project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/anakinj/jwt-aws-kms/blob/main/CODE_OF_CONDUCT.md).
