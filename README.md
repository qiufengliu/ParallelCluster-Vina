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
### 分子库拆分
用户可以通过命令行模式下执行如下命令，将当前目录下的分子库拆分成单个的小分子并保存至/fsx/sdf目录。这里我们将单个分子库(sdf文件)提交一个job到m5队列中
```shell
bash 1-Prepare_sdf.sh
```
### 分子构象生成
分子库拆分以后得到的每一个分子均保存在/fsx/sdf目录下，一个分子对应为一个sdf文件。这些分子从结构上看都是平面的，没有三维构象。由于对接需要分子的三维构象，所以需要先为每一个分子生成三维构象。这里我们通过软件Open Babel来实现。
用户在Shell模式通过运行如下脚本执行提交任务实现上述功能
```shell
bash 2-Generate_3D_comformation.sh
```
### 分子格式转换
同样我们通过脚本将3D_mol2目录下的每一个Mol_00xxxx文件夹提交一个job将分子mol2格式转化为pdbqt格式，生成的pdbqt结果保存在pdbqt目录下对应的Mol_00xxxx文件夹内。
```shell
bash 3-GeneratePDBQT.sh
```
### 批量虚拟筛选
```shell
bash 4-docking.sh /fsx/acceptor/config.txt /fsx/acceptor/1a3w-accptor.pdbqt
```
### 总结
通过分析结果我们可到结果输出文件，每个分子对应一个对接分数，我们重点关注对接分数较低的分子。完成虚拟筛选之后后续的分子可
用于实验验证活性，若有活性则获得该蛋白靶点的先导化合物（Hit）用于后续的药物开发。通过Amazon ParallelCluster创建的高性能>集群大规模调用海量计算资源，轻松在几个小时内完成百万级别的分子对接任务，在加速药物研发周期早期发挥极为重要的作用。
