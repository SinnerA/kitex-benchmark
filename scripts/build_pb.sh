#!/bin/bash

GOEXEC=${GOEXEC:-"go"}

# clean
rm -rf output/ && mkdir -p output/bin/ && mkdir -p output/log/

# build kitex
$GOEXEC mod edit -replace=github.com/apache/thrift=github.com/apache/thrift@v0.13.0
$GOEXEC mod edit -replace=github.com/cloudwego/kitex=github.com/cloudwego/kitex@3af6c384e202323e43f6f89fb08146c6013fb1f0
$GOEXEC mod edit -replace=github.com/cloudwego/netpoll-http2=github.com/cloudwego/netpoll-http2@5756b8c33a14f561ea213d4a2b5cbaa52ef365cd
$GOEXEC mod tidy
$GOEXEC build -v -o output/bin/kitex_bencher ./protobuf/kitex/client
$GOEXEC build -v -o output/bin/kitex-mux_bencher ./protobuf/kitex-mux/client
$GOEXEC build -v -o output/bin/kitex_reciever ./protobuf/kitex
$GOEXEC build -v -o output/bin/kitex-mux_reciever ./protobuf/kitex-mux

# build others
$GOEXEC mod edit -replace=github.com/apache/thrift=github.com/apache/thrift@v0.14.2
$GOEXEC mod tidy
$GOEXEC build -v -o output/bin/grpc_bencher ./protobuf/grpc/client
$GOEXEC build -v -o output/bin/rpcx_bencher ./protobuf/rpcx/client
$GOEXEC build -v -o output/bin/arpc_bencher ./protobuf/arpc/client
$GOEXEC build -v -o output/bin/grpc_reciever ./protobuf/grpc
$GOEXEC build -v -o output/bin/rpcx_reciever ./protobuf/rpcx
$GOEXEC build -v -o output/bin/arpc_reciever ./protobuf/arpc
