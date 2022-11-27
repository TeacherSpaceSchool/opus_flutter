const String getContactQuery = '''contact {
                            createdAt
                            name
                            image
                            addresses {address geo}
                            email
                            phone
                            info
                            social
                            _id
                          }''';
