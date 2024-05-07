# What is this?

VPCとサブネットを作成するためのTerraformのコードです。

目的や作った理由、使い方などは以下の記事に書いています。

[TerraformでAWSのお気軽VPC/サブネット作り](https://zenn.dev/keioni/articles/c60b03a45bb5f8)

# How to use

`./vpc-test` ディレクトリ以下で

```
terraform init
```

をしたあと、plan & apply すれば完了です。

```
terraform plan
terraform apply
```

確認したあとは、削除してください。

```
terraform destroy
```

# Prerequisites

* AWSでVPCに関するアクセス権を持ったIAMユーザーで実行する必要があります
    * テスト環境であれば `AdministratorAccess` が付与されたIAMユーザーで問題ありません
* Terraform CLIがインストールされている必要があります
    * macOS なら `brew install terraform` でインストールできます

# Warning

* `private.tf` を使うと、NATゲートウェイと Elastic IP が作成されます
    * NATゲートウェイは時間課金なので、使い終わったら削除してください
    * プライベートサブネットは、このサンプルコードの本質ではないので、必須のものではありません<br>必要ない場合は `private.tf` を削除してください
