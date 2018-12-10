# Example using shim separated from fabric

The enccc sample from fabric `github.com/hyperledger/fabric/examples/chaincode/go/enccc_example` is chosen to illustrate separation of GO shim from fabric (rather than the simpler `example02`).

The only modification to the sample is to replace `github.com/hyperledger/fabric/core/chaincode/shim` with `github.com/muralisrini/shim`.

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
Fabric currently uses `hyperledger/fabric-ccenv` to build GO chaincode image (at instantiation time) where the ccenv image contains shim. Now that shim has been seperated out and combined with the enccc_example pakage, we no longer need ccenv to provide the shim dependency. We will provide a different builder image to build enccc_example.

### Use Dockerfile to build "builder" image
```
docker build -t mybuilder:latest .
```

### Point core.yaml to "mybuilder"
Replace
```
builder: $(DOCKER_NS)/fabric-ccenv:latest
```
with
```
builder: mybuilder:latest
```

## Start the network
Start peer and orderer

Create and join channel `my-ch`.

## Install and Instantiate enccc
```
peer chaincode install enccc.pak

peer chaincode instantiate -n enccc -v 0 -C my-ch  -c '{"Args":[""]}'
```

## Test
Follow the README instructions in https://github.com/hyperledger/fabric/tree/master/examples/chaincode/go/enccc_example to test.

## Conclusion
The external `github.com/muralisrini/shim` is packaged with enccc_example using the `dep` tool. We provide a simpler builder to build the chaincode image that does not use the shim from fabric.

```
NOTE 1 - This did not require fabric change beyond configuration change (using our own builder instead ccenv image).

Note 2 - The building of the chaincode image itself is done in fabric. Eliminating this is more involved and would require fabric changes.
```
