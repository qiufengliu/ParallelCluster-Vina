# ParallelCluster-Vina
Run AutoDock Vina with Amazon ParallelCluster
1. Install Amazon ParallelCluster
# SSH登录PCluster客户端, 安装所需软件
sudo yum -y install python3 python3-pip
# 使用pip 安装Parallel Cluster
python3 -m pip install "aws-parallelcluster" --upgrade --user
# Install Node Version Manager and Node.js (required due to AWS Cloud Development Kit (CDK) 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
chmod ug+x ~/.nvm/nvm.sh
source ~/.nvm/nvm.sh
nvm install node
node --version
# 如果因为firewall的问题导致无法安装NodeJS可以使用如下方式手动安装
wget https://nodejs.org/dist/v16.13.0/node-v16.13.0-linux-x64.tar.xz
tar -xvf node-v16.13.0-linux-x64.tar.xz
sudo mv node-v16.13.0-linux-x64 /usr/local/node
echo "export PATH=$PATH:/usr/local/node/bin" >>~/.bashrc
# 激活
source ~/.bashrc
# 检查版本
node -v
npm -v
2. 准备PCluster集群配置文件
命令行方式
https://docs.aws.amazon.com/zh_cn/parallelcluster/latest/ug/pcluster.configure-v3.html
pcluster configure --region us-west-2 --config config.yaml
手动编辑配置文件
集群的文件可以参考链接
https://docs.aws.amazon.com/zh_cn/parallelcluster/latest/ug/cluster-configuration-file-v3.html
3. 创建Pcluster集群
pcluster create-cluster --cluster-configuration config.yaml --cluster-name hpc --rollback-on-failure false 
4. 登录集群节点
pcluster ssh --cluster-name hpc -i key.pem

