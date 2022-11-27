const String subscriptionDocument = '''
  subscription  {
    reloadData {
        mailing
        notification 
            {
                _id
                createdAt
                type
                who {login _id name avatar reiting completedWorks}
                whom {login _id name}
                message
                url
                order {_id name status}
                application {_id}
                chat {_id}
                title
            }
        message 
            {
                _id
                createdAt
                who {_id name}
                whom {_id name}
                type
                text
                file
                chat
            }
    }
  }
  ''';

const String receiveWS = '''mutation (\$_id: ID!) {
                        receiveWS(_id: \$_id) 
                    }''';
