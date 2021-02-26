# devSetup

Follow below steps to prepare devlopment setup in Ubuntu Server.

Step 1: Give executable permission to start.sh file by running below command

        chmod +x start.sh
        
Step 2: Execute the script and start dev-setup by running below command

        ./start.sh
        
        
To upgrade elasticsearch from version 5.0.0 to version 7.6.2 and retain data/indices of elasticsearch of version 5.0.0
first we have to reindex indices of es version 5.0.0 with any elasticsearch version 6.x and then after reindexing we should move to es version 7.

Follow below steps achieve above scenario

Step 1: Edit docker-compose.yaml file, comment(put #) line image: elasticsearch:5.0.0 and uncomment(remove #) image:elasticsearch:6.8.13
        
        nano docker-compose.yaml
        
Step 2: To take backup of existing state of indices data of elasticsearch:5.0.0 run below commands.
       
        cd /dev-setup/elasticsearch/
        
        sudo tar -cvzf /tmp/data.tar.gz data
        
        sudo cp /tmp/data.tar.gz .
                
        cd -
        
Step 3: run below commands to remove and redeploy elasticsearch service.
     
        sudo docker service rm dev_fx-elasticsearch
                     
        sudo chown 1000:1000 -R /dev-setup/elasticsearch/data
        
        sudo docker stack deploy -c docker-compose.yml dev
        
        sudo docker ps

Step 4: Verify runing elasticsearch instance and existing indices in that elasticsearch instance by running below commands
        
        curl -s http://localhost:9200
        
        curl -s -X GET 'http://localhost:9200/_cat/indices/%2A?v=&s=index:desc'
Step 5: Give executable permission to reindex-elasticsearch.sh file by running below command
        
        sudo chmod +x reindex-elasticsearch.sh
        
Step 6: Reindex indices of elasticsearch 5 into elasticsearch-6  run below  command to execute reindex-elasticsearch.sh script
    
        ./reindex-elasticsearch.sh
        
Step 7: Edit elasticserch.yml file and uncomment(remove #) line #discovery.type: single-node
  
        nano elasticsearch.yml

Step 8: Edit docker-compose.yaml file, comment(put #) line image: elasticsearch:6.8.13 and uncomment(remove #) image:elasticsearch:7.6.2

        nano docker-compose.yaml

Step 9: run below commands to remove and redeploy elasticsearch service.
     
        sudo docker service rm dev_fx-elasticsearch
                                    
        sudo docker stack deploy -c docker-compose.yml dev
        
        sudo docker ps
        

Step 10: Verify runing elasticsearch instance and existing indices in that elasticsearch instance by running below commands
        
        curl -s http://localhost:9200
        
        curl -s -X GET 'http://localhost:9200/_cat/indices/%2A?v=&s=index:desc'       

