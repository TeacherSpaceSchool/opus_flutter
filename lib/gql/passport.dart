const String getProfile = '''getStatus {
                            role
                            status
                            login
                            city
                            addresses {address geo apartment}
                            _id
                            specializations {category subcategory end discount enable}
                            phone
                            name
                            unreadBN {notifications0 notifications1}
                            verification
                          }''';

const String signinuser = '''mutation (\$name: String, \$login: String!, \$password: String!, \$code: String, \$isApple: Boolean) {
                        signinuser(name: \$name, login: \$login, password: \$password, code: \$code, isApple: \$isApple) {
                          role
                          status
                          login
                          city
                          _id
                          phone
                          name
                          specializations {category subcategory end discount enable}
                          unreadBN {notifications0 notifications1}
                          addresses {address geo apartment}
                          verification
                          jwt
                        }
                    }''';

const String setDevice = '''mutation (\$device: String!) {
                        setDevice(device: \$device)     
                    }''';
