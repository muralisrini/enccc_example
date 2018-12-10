# EnCCC sample modified to use github.com/muralisrini/shim

The enccc sample from fabric `github.com/hyperledger/fabric/examples/chaincode/go/enccc_example` is a bit more complex than "example02". It is chosen to illustrate separation of GO shim from fabric.

The sample is copied as is and modified to replace `github.com/hyperledger/fabric/core/chaincode/shim` with `github.com/muralisrini/shim`.

## Create the enccc install package
### Clone encc 
mkdir < path >/enccc/src
  
export GOPATH=< path >/enccc
  
cd < path >/enccc/src
  
git clone https://github.com/muralisrini/enccc_example.git

### Get dependencies
cd enccc_example

dep ensure

This pulls in `github/muralisrini/shim` along with its dependencies.

### Create install package
peer chaincode package  -n enccc -v 0 -p enccc_example enccc.pak

This contains the shim built from `github.com/muralisrini/shim`.

## Create the builder image
Fabric currently uses "ccenv" to build GO chaincode image (at instantiation time.) ccenv image contains shim. Now that shim has been seperated out and combined with the enccc_example pakage, we will provide a different builder image to build enccc_example.

### Use Dockerfile to build "builder" image
docker build -t mybuilder .

### Point core.yaml to "mybuilder"
Replace
builder: $(DOCKER_NS)/fabric-ccenv:latest
with
builder: mybuilder:latest

## Start the network
Start peer and orderer

Create and join channel "my-ch".

## Install and Instantiate enccc
peer chaincode install enccc.pak

peer chaincode instantiate -n enccc -v 0 -C my-ch  -c '{"Args":["a"]}'

## Test
Follow the README instructions in https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/enccc_example to test
