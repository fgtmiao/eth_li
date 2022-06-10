# 知识付费和激励学习的大饼project

## 文件结构介绍
 - `./src/contracts`中的文件是智能合约。其中
    - `Courses.sol`是和课程相关的内容，
    - `Token.sol`是对我们的货币的定义，
    - `EthSwap.sol`是货币兑换合约，
    - `Migrations.sol`是网上抄的我也不知道干什么用的合约。
 - `./src/components`中的文件是前端。
 - `./migrations/2_deploy_contracts.js`是初始化制衡合约的脚本。当你在`./src/contracts`添加新的智能合约文件时，需要对应地修改这个文件中的内容。
 - `./src/abis`中的文件是系统自动根据智能合约生成的，一般不用管它


## 目前进展
 - 前端（react.js）
    - 实现了我们的货币和以太坊之间的兑换（其实是网上抄的）

不过，前端在作业中是不用提交的，所以我们完全可以只用写后端的智能合约和测试代码，用测试代码或`truffle console`和后端的智能合约交互。

## 如何运行本项目
可以看视频中5:42-12:50 
1. 在电脑上下载 nodejs Ganache
2. 在Chrome浏览器上下载插件 Metamask
3. 打开Ganache，选择quick start
4. 在eth_swap目录下运行
```shell
# 安装truffle
npm install -g truffle@5.1.14
# 安装本项目的依赖库（可能需要几分钟时间）
npm install
npm install --save identicon.js@^2.3.3
# 编译智能合约
truffle compile
# 将智能合约部署到自己测试用的区块链上
truffle migrate
# 开启前端服务
npm run start
```

5. 在Chrome浏览器上打开http://localhost:3000/，并参考这个网址的说明配置你的metamask让它能连上你的测试用链：https://www.icode9.com/content-4-1276722.html 不过第一步要点击"不，我已经有一个账户助记词了"，然后将你ganache应用上的助记词复制进去。
6. 然后你就可以看到一个精美的代币兑换界面了
