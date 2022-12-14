import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../widget/app/snack_bar.dart';
import '../module/const_value.dart';
import '../riverpod/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

late GraphQLClient gqlClient;

Future<GraphQLClient> generateGqlClientService(jwt) async {
  final HttpLink httpLink = HttpLink(urlGQL, defaultHeaders: {
    'type': 'service',
    ...jwt!=null?{'authorization': 'Bearer $jwt'}:{}
  });
  final websocketLink = WebSocketLink(
      urlGQLws,
      config: SocketClientConfig(
        initialPayload: {
          'type': 'service',
          ...jwt!=null?{'authorization': 'Bearer $jwt'}:{}
        },
      )
  );
  Link link = Link.split((request) => request.isSubscription, websocketLink, httpLink);
  final GraphQLClient gqlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: null),
    defaultPolicies: DefaultPolicies(
      watchQuery: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.ignore
      ),
      query: Policies(
        fetch: FetchPolicy.noCache,
        error: ErrorPolicy.all,
      ),
      mutate: Policies(
          error: ErrorPolicy.all
      ),
    ),
  );
  return gqlClient;
}

Future<GraphQLClient> generateGqlClient(jwt) async {
  final HttpLink httpLink = HttpLink(urlGQL, defaultHeaders: {
    'type': 'app',
    ...jwt!=null?{'authorization': 'Bearer $jwt'}:{}
  });
  final websocketLink = WebSocketLink(
      urlGQLws,
      config: SocketClientConfig(
        initialPayload: {
          'type': 'service',
          ...jwt!=null?{'authorization': 'Bearer $jwt'}:{}
        },
      )
  );
  Link link = Link.split((request) => request.isSubscription, websocketLink, httpLink);
  gqlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: HiveStore()),
    defaultPolicies: DefaultPolicies(
      watchQuery: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.ignore
      ),
      query: Policies(
        fetch: FetchPolicy.noCache,
        error: ErrorPolicy.all,
      ),
      mutate: Policies(
          error: ErrorPolicy.all
      ),
    ),
  );
  return gqlClient;
}

Future<Map<String, dynamic>?> getQuery({required List<String> queries, List<Map<String, dynamic>>? variables, List<String>? queryVariables}) async {
  String queries_ = '';
  for(int i = 0; i < queries.length; i++) {
    if(i!=0) {
      queries_ += '\n';
    }
    queries_ += queries[i];
  }
  String queryVariables_ = '';
  if(queryVariables!=null) {
    for (int i = 0; i < queryVariables.length; i++) {
      if (i != 0) {
        queryVariables_ += ', ';
      }
      queryVariables_ += queryVariables[i];
    }
  }
  Map<String, dynamic> variables_ = {};
  if(variables!=null) {
    for (int i = 0; i < variables.length; i++) {
      variables_ = {...variables_, ...variables[i]};
    }
  }
  final QueryResult result = await gqlClient.query(QueryOptions(
      variables: variables_,
      document: gql('''query ($queryVariables_) {
                        $queries_
                    }''')));
  final Map<String, dynamic>? res = result.data;
  if(result.exception!=null) {
    if (kDebugMode) {
      print(result.exception);
    }
    showSnackBar(text: '????????????', type: 'e');
  }
  return (res);
}

Future<Map<String, dynamic>?> sendMutation({required String mutation, required Map<String, dynamic> variables}) async {
  final QueryResult result = await gqlClient.mutate(MutationOptions(
      variables: variables,
      document: gql(mutation)));
  final Map<String, dynamic>? res = result.data;
  if(result.exception!=null) {
    if (kDebugMode) {
      print(result.exception);
    }
    showSnackBar(text: '????????????', type: 'e');
  }
  return (res);
}