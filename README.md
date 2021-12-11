ParallelCluster-Vina
Run AutoDock Vina with Amazon ParallelCluster
### Install Amazon ParallelCluster
SSH登录PCluster客户端, 安装所需软件
```shell
sudo yum -y install python3 python3-pip
```
使用pip 安装Parallel Cluster
```shell
python3 -m pip install "aws-parallelcluster" --upgrade --user
```
Install Node Version Manager and Node.js (required due to AWS Cloud Development Kit (CDK) 
```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
chmod ug+x ~/.nvm/nvm.sh
source ~/.nvm/nvm.sh
nvm install node
node --version
```
如果因为firewall的问题导致无法安装NodeJS可以使用如下方式手动安装
```shell
wget https://nodejs.org/dist/v16.13.0/node-v16.13.0-linux-x64.tar.xz
tar -xvf node-v16.13.0-linux-x64.tar.xz
sudo mv node-v16.13.0-linux-x64 /usr/local/node
echo "export PATH=$PATH:/usr/local/node/bin" >>~/.bashrc
source ~/.bashrc
npm -v
```
### 准备PCluster集群配置文件
#### 命令行方式
命令行方式配置参考[教程]（https://docs.aws.amazon.com/zh_cn/parallelcluster/latest/ug/pcluster.configure-v3.html）
```shell
pcluster configure --region us-west-2 --config config.yaml
```
#### 手动方式
集群的文件可以参考[链接]
（https://docs.aws.amazon.com/zh_cn/parallelcluster/latest/ug/cluster-configuration-file-v3.html）
### 创建Pcluster集群
```shell
pcluster create-cluster --cluster-configuration config.yaml --cluster-name hpc --rollback-on-failure false 
```
### 登录集群节点
```shell
pcluster ssh --cluster-name hpc -i key.pem
```
### 创建FSx for Lustre文件系统
### 下载并安装测试工具
提前下载工具vina,Open Babel, MGLTools到/fsx目录
### 安装测试软件
```shell
cd /fsx
mv vina_1.2.3_linux_x86_64 vina
sudo chmod +x vina
./vina --help
# 安装Open Babel 参考https://open-babel.readthedocs.io/en/latest/Installation/install.html#compiling-open-babel
cd /fsx
tar -zxvf openbabel-openbabel-2-4-0.tar.gz
mkdir -p /fsx/build
cd build
cmake ../openbabel-openbabel-2-4-0 -DCMAKE_INSTALL_PREFIX=/fsx/openbabel -DCMAKE_BUILD_TYPE=DEBUG
make -j4
make install
# 安装MGLTools
cd /fsx
chmod +x mgltools_Linux-x86_64_1.5.7_install
./mgltools_Linux-x86_64_1.5.7_install
cd /fsx/mgltools/mgltools_x86_64Linux2_1.5.7
./install -d /fsx/mgltools
```
