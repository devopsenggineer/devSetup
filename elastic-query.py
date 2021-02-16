from elasticsearch5 import Elasticsearch
import datetime
es = Elasticsearch('http://fx-elasticsearch:9200')

#doc = {
#    'author': 'kimchy',
#    'text': 'Elasticsearch: cool. bonsai cool.',
#    'timestamp': datetime.datetime.now()
#}
#res = es.index(index="test-index",doc_type="test", id=1, body=doc)
#print(res['result'])

#res = es.get(index="test-index", id=1)
#print(res['_source'])

#es.indices.refresh(index="test-index")
indexes=es.indices.get('*')
#print(indexes)
for j in range(0,10):
    print("value of j is: ", j)
    for i in indexes:
        print(i)
        print(" ")

        res = es.search(index=i, body={"query": {"match_all": {}}, "size": 1000})
        #res = es.search(index="fx-testsuite-responses", body={"query": {"match_all": {}}, "size": 1000})
        #print((res))
        #print("Got %d Hits:" % res['hits']['total']['value'])

        for hit in res['hits']['hits']:
            #print("Hello")
            #print("%(timestamp)s %(author)s: %(text)s" % hit["_source"])
            #es.index(index="fx-testsuite-responses",body={hit})
            a=hit["_source"]
            e = es.index(index=i,doc_type="test" ,body=a)
            #e = es.index(index="fx-testsuite-responses",doc_type="test" ,body=a)


