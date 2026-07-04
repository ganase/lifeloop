# App Store公開準備メモ

最終更新日: 2026年7月3日

このメモは、Knock Knock 株式会社が提供する現在のlifeloop実装を前提にしたApp Store Connect入力用の控えです。サーバー送信、アカウント、広告、分析SDK、外部SDKを追加した場合は、プライバシー回答と公開文書を更新してください。

## 公開ページURL

GitHub Pagesを `main` ブランチの `/docs` から配信する前提です。

| 用途 | URL |
| --- | --- |
| トップ | `https://ganase.github.io/lifeloop/` |
| Privacy Policy URL | `https://ganase.github.io/lifeloop/privacy.html` |
| Support URL | `https://ganase.github.io/lifeloop/support.html` |
| Terms URL | `https://ganase.github.io/lifeloop/terms.html` |

GitHub Pagesをまだ有効化していない場合は、GitHubのRepository SettingsからPagesを有効化し、Sourceを `Deploy from a branch`、Branchを `main`、Folderを `/docs` にしてください。

## App Privacy回答案

現在のコードでは、利用者データは端末内に保存され、Knock Knock 株式会社のサーバーや第三者へ送信されません。この前提では、App Store ConnectのApp Privacyは次の回答が妥当です。

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
- MapKit、Core Location、UserNotificationsなどAppleのフレームワークは使用します。AppleがOSまたはAppleサービスとして処理するデータは、Knock Knock 株式会社側の収集データとして扱いません。
- 問い合わせで利用者がGitHub Issues、App Storeレビュー、メールなどに入力した情報は、問い合わせ対応のために使われます。

## Info.plistの権限説明

現在の `Info.plist` には次の位置情報説明があります。

- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `NSLocationAlwaysUsageDescription`

通知許可は `NotificationService.requestAuthorization()` で `.alert`, `.sound`, `.badge` を要求します。

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

- GitHub Pagesで `privacy.html` と `support.html` がブラウザからアクセスできることを確認する。
- App Store ConnectのPrivacy Policy URLとSupport URLに公開URLを入力する。
- App Store ConnectのApp Privacy回答が、現在の実装と一致していることを確認する。
- App Store上の販売元/提供者名、サポート窓口、問い合わせ導線がKnock Knock 株式会社の実態と一致していることを確認する。
- 位置情報と通知の許可説明が、アプリ内表示、`Info.plist`、公開文書で矛盾していないことを確認する。
- 実機で、位置情報許可、通知許可、Placeのテスト通知、Log画面遷移を確認する。
- 利用規約と個人情報保護方針は、公開前に事業者情報と配信地域に照らして最終確認する。

## 参照した公式情報

- Apple App Privacy Details: https://developer.apple.com/app-store/app-privacy-details/
- Apple App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- 個人情報保護委員会 法令・ガイドライン等: https://www.ppc.go.jp/personalinfo/legal/
