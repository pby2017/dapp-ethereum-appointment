# 약속 관리 Dapp

약속을 생성하고 관리하는 Dapp으로, 토큰 보증금으로 노쇼를 방지하고 신뢰를 제공합니다.

## 시작하기

### 준비사항

1. HTML, CSS, Javascript knowledge
2. Geth
   * Windows
     1. [Geth & Tools 1.7.3](https://geth.ethereum.org/downloads/)
   * Mac
     1. [Go language recently version](https://golang.org/dl/)
     2. git clone https://github.com/ethereum/go-ethereum.git
        1. move directory to 'go-ethereum' directory
        2. execute command 'make geth' (= Makefile)
        3. Run geth tool at 'go-ethereum/build/bin/'
3. [Remix ethereum org](http://remix.ethereum.org/)

## 테스트 (방법)

[참고영상](https://youtu.be/ip7vvwMyWv4)

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

## 변경사항
* 2019/ 08/ 31 23:35
master 브랜치와 final 브랜치를 분리했습니다. (개발 전과 개발 후 코드로 나눔)
* 2019/ 03/ 15 15:36
UI 부트스트랩 적용하여 배치 수정했습니다.
* 2019/ 03/ 11 19:22
참석 확인 문제 수정했습니다.
