# lifeloop App Store Connect Development Notes

最終更新日: 2026年7月12日

この文書は開発・提出作業用の控えです。ユーザー向け公開ページには、App Store Connectの入力欄名や提出手順を掲載しません。

## Bundle ID

| 項目 | 値 |
| --- | --- |
| Product Bundle Identifier | `at.knockknock.lifeloop` |
| Development Team | `34HY3FLLN6` |
| Display Name | `lifeloop` |

## App Store Connect向けURL

| 用途 | URL |
| --- | --- |
| Marketing URL | `https://www.knockknock.at/products/lifeloop` |
| Privacy Policy URL | `https://knockknock-at.github.io/lifeloop/docs/lifeloop/privacy.html` |
| Support URL | `https://knockknock-at.github.io/lifeloop/docs/lifeloop/support.html` |
| Terms URL | `https://knockknock-at.github.io/lifeloop/docs/lifeloop/terms.html` |
| lifeloop ドキュメント直URL | `https://knockknock-at.github.io/lifeloop/docs/lifeloop/` |
| 会社共通トップ | `https://knockknock-at.github.io/lifeloop/docs/` |

App Store ConnectのMarketing URLは、Knock Knockの商品ページを指定します。Privacy Policy URLとSupport URLは、Apple Reviewが直接確認しやすいようにHTML直URLを指定します。商品ページからも、ログインなしで各ドキュメントへ到達できる状態を維持してください。

## App Store提出用スクリーンショット

`AppStoreScreenshots/final/` に提出用PNGを保存しています。

| ファイル | サイズ |
| --- | --- |
| `01_home_map.png` | 1320 x 2868 |
| `02_place.png` | 1320 x 2868 |
| `03_act.png` | 1320 x 2868 |
| `04_steps.png` | 1320 x 2868 |
| `05_log.png` | 1320 x 2868 |

現在のXcode設定はiPhone専用のため、iPadスクリーンショットは不要な想定です。App Store Connect上でiPad欄が表示された場合は、ターゲット設定と対応デバイスを再確認してください。

## App Privacy回答案

現在の実装では、利用者データは端末内に保存され、Knock Knock 株式会社のサーバーや第三者へ送信されません。この前提では、App Store ConnectのApp Privacyは次の回答が妥当です。

| 項目 | 回答案 |
| --- | --- |
| Data Collected | No |
| Tracking | No |
| Third-Party Advertising | No |
| Developer Advertising or Marketing | No |
| Analytics SDK | No |
| Third-party SDKs | No |

補足:

- 位置情報はアプリ機能のために端末上で使用しますが、Knock Knock 株式会社または第三者がアクセスできる形で端末外へ送信していません。
- MapKit、Core Location、UserNotificationsなどAppleのフレームワークは使用します。
- 問い合わせで利用者がGitHub Issues、App Storeレビュー、メールなどに入力した情報は、問い合わせ対応のために使われます。

## Review Notes案

```text
lifeloop is a local-first habit notification app. It does not require an account and does not upload location, habit, or log data to a server.

Location permission is used to register places and to trigger local notifications when the device enters or exits registered regions. Notification permission is used only for local notifications.

To test the notification flow without physically moving:
1. Launch the app.
2. Allow location and notification permissions.
3. Open the Place tab.
4. Swipe left on a place row and tap "テスト".
5. A local notification is delivered and can be opened to the Log screen.
```

## 公開前チェック

- `PRODUCT_BUNDLE_IDENTIFIER` が `at.knockknock.lifeloop` になっていること。
- Marketing URL `https://www.knockknock.at/products/lifeloop` がログインなしで開けること。
- Privacy Policy URLとSupport URLがログインなしで開けること。
- `AppStoreScreenshots/final/` のPNGをApp Store Connectにアップロードすること。
- App Privacy回答が現行実装と一致していること。
- 実機で、位置情報許可、通知許可、Placeのテスト通知、Log画面遷移を確認すること。
