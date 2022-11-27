const String getFaqsQuery = '''faqs(search: \$search, skip: \$skip) {
                            _id
                            url
                            title
                            video
                            createdAt
                            roles
                        }''';
const String getFaqsVariables = '\$search: String, \$skip: Int';