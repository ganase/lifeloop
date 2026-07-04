# App Privacy回答控え

作成日: 2026-07-03
対象アプリ: lifeloop
提供者: Knock Knock 株式会社

## 推奨回答

現状の実装では、利用者データは端末内に保存され、Knock Knock 株式会社のサーバーや第三者へ送信されません。この前提では、App Store ConnectのApp Privacyは次の回答が妥当です。

| App Store Connect項目 | 回答案 |
| --- | --- |
| Data Collected | No |
| Tracking | No |
| Third-Party Advertising | No |
| Developer Advertising or Marketing | No |
| Analytics | No |
| Third-party SDKs that collect data | No |

## 根拠

- アカウント登録、ログイン、ユーザーID発行がありません。
- 独自サーバー、広告SDK、分析SDK、第三者トラッキングSDKを使用していません。
- 位置情報は端末上で、場所登録、地図表示、Region Monitoringによる通知判定に使います。
- Place、Act、Course、Step、Logは端末内のApplication SupportにJSONとして保存されます。
- 通知はUserNotificationsによるローカル通知です。
- MapKit、Core Location、UserNotificationsなどAppleのフレームワークは使用します。AppleがOSまたはAppleサービスとして処理する情報は、Knock Knock 株式会社側の収集データとして扱いません。

## 更新が必要になる条件

次のいずれかを追加した場合は、App Privacy回答と公開中の個人情報保護方針を更新してください。

- サーバー同期
- アカウント登録
- 問い合わせフォームのアプリ内実装
- 広告
- 分析SDK
- クラッシュ解析SDK
- Push通知サーバー
- 外部AI/API連携
- CloudKitやFirebaseなどのクラウド保存
- 位置情報、履歴、端末ID、メールアドレスなどの端末外送信

## Apple公式情報との対応

Appleは、App Store Connectで第三者パートナーを含むアプリのプライバシー慣行を回答する必要があると説明しています。また、端末上だけで処理され、サーバーへ送信されない位置情報等は「収集」扱いにしない追加 guidance を示しています。
