# 약속 관리 Dapp

약속을 생성하고 관리하는 Dapp으로, 토큰 보증금으로 노쇼를 방지하고 신뢰를 제공합니다.

## 시작하기

### 준비사항

1. HTML, CSS, Javascript knowledge
2. [Geth & Tools 1.7.3](https://geth.ethereum.org/downloads/)
3. [Remix ethereum org](http://remix.ethereum.org/)

## 테스트 (방법)

[참고영상](https://youtu.be/jpPDz_KSGAM)

1. Geth (dev mode & rpcport except 8545) 실행
```
geth --datadir testNode1 --networkid 9865 --rpcapi "personal,db,eth,net,web3,miner" --rpc --rpcaddr "0.0.0.0" --rpcport 8544 --rpccorsdomain "*" --nodiscover --maxpeers 0 --dev console
```
2. [Remix ethereum](http://remix.ethereum.org/)에서 Geth Web3 Provider 연결
3. [Remix ethereum](http://remix.ethereum.org/)에 apmt.sol 파일의 소스코드를 복사
4. [Remix ethereum](http://remix.ethereum.org/)에서 contract deploy(배포)
5. [Remix ethereum](http://remix.ethereum.org/)에서 address와 ABI 각각 복사 후 myContract.js 파일의 address와 ABI 수정
6. myContract.js 파일의 secret 값을 Geth 내 eth.coinbase 계정의 비밀번호로 수정 (dev mode의 비밀번호는 공백 "")
7. index.html 파일 실행 후 사용

## UI
```
※ 사용법은 html 실행시 하단에 정리되어 있음.
```
![UI image](https://github.com/pby2017/study-apmt-geth-dapp/blob/master/image/UI.jpg)
