# simple-rio-lambda

Python 3.6 + Rasterio on AWS Lambda

=========

### Requierement
  - AWS Account
  - awscli
  - Docker
  - npm (serverless)


### Create and deploy

```
make package

npm install -g serverless

sls deploy
```


### Use

```Python
import json

import boto3

client = boto3.client('lambda', region_name='us-west-2')

response = client.invoke(
    FunctionName= 'simple-rio-lambda-production-test',
    InvocationType='RequestResponse',
    LogType='None',
    Payload=json.dumps({"scene": "LC08_L1TP_013030_20170520_20170520_01_RT"})
)
print(json.loads(response['Payload'].read().decode()))
```


#### Links
[lambda-rasterio](https://github.com/perrygeo/lambda-rasterio)
[remotepixel-tiler](https://github.com/RemotePixel/remotepixel-tiler)
