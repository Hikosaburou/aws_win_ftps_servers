# aws_win_ftps_servers
FTPSサーバーを設定するため、EC2(Windows)2台をVPC上に構築する

## できるもの

AWSアカウント上に以下を作成する

- VPC
    - Public Subnet x 2
    - Private Subnet x 2
    - Route Table (for Public, for Private)
    - 
- EC2インスタンス (Windows) x 2
    - 特定IPからRDPアクセスを許可
    - Public Subnetに配置

## 準備

Terraformでのデプロイにあたって、以下の準備を行う

### SSHキーペアの作成

EC2インスタンスにアクセスするためのキーペアを作成する (Windowsインスタンスのパスワードを展開する際にOPENSSHフォーマットだと失敗するので、 `-m PEM` オプションをつけてPEMで作成する。
)

```
$ ssh-keygen -t rsa -b 4096 -m PEM
```

コンソールでEnterし続けると `~/.ssh/id_rsa`, `~/.ssh/id_rsa.pub` が作成されるので適宜リネームする

```
$ mkdir -p ~/.ssh/keys
$ mv ~/.ssh/id_rsa ~/.ssh/keys/test
$ mv ~/.ssh/id_rsa.pub ~/.ssh/keys/test.pub
```

### クレデンシャル情報を設定

環境変数を設定する。(`AWS_PROFILE` 設定を推奨)

```
### アクセスキーを直接指定する場合 (非推奨)
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx

### 名前付きプロファイルを指定する場合 (推奨)
export AWS_PROFILE="my-profile"

### 名前付きプロファイルでIAMロールを利用する場合、以下を追加する
export AWS_SDK_LOAD_CONFIG=1
```

### terraform.tfvars の作成

`terraform.tfvars` に個別の変数を埋め込む。以下の `$HOME` はユーザーのホームディレクトリに適宜書き換える (変数展開ができなかったため)

```
public_key_path="$HOME/.ssh/keys/test.pub"
my_ip="x.x.x.x/32"
```

各項目に以下要領で値を入れる

| 項目 | 内容 |
|  ------ | ------ |
|  public_key_path | 公開鍵ファイルのパス |
|  my_ip | SSHの接続元IP |

## デプロイ

以下コマンドで構成を確認する。

```
$ terraform plan
```

以下コマンドで構成をAWS環境にデプロイする。

```
$ terraform apply
```

EC2インスタンスにRDP接続する (コンソールからPassを取得する際にSSH秘密鍵を使う)