# lifeloop Apple Submission Package

作成日: 2026-07-03
対象アプリ: lifeloop
提供者: Knock Knock 株式会社
保存先: `/Users/nagnag/Lifeloop/AppStoreSubmission/2026-07-03-lifeloop-apple-submission/`

このフォルダは、App Store ConnectとApp Reviewに転記・提出するための控えです。公開ページそのものは `docs/` にあります。

## ファイル一覧

| ファイル | 用途 |
| --- | --- |
| `app-store-connect-fields-ja.md` | App Store Connectの商品ページ項目の日本語案。 |
| `app-review-notes.txt` | App Review Notes欄へ貼り付ける審査メモ。 |
| `app-privacy-answers.md` | App Privacy回答の控え。 |
| `location-and-notification-explanation.md` | 位置情報・通知利用目的の説明。 |
| `export-compliance.md` | 輸出コンプライアンス/暗号化質問の判断メモ。 |
| `public-urls.md` | Privacy Policy URL、Support URL、Terms URLの控え。 |
| `pre-submission-checklist.md` | 提出前チェックリスト。 |

## 重要な前提

- lifeloopはアカウント登録を持ちません。
- lifeloopは独自サーバーへ位置情報、場所、Act、Course、Step、Logを送信しません。
- lifeloopは広告SDK、分析SDK、第三者トラッキングSDKを使用しません。
- 位置情報は、登録地点への到着・離脱判定、地図表示、現在地からの場所登録に使います。
- 通知は端末内のローカル通知として表示します。
- 将来、サーバー送信、アカウント、広告、分析SDK、外部SDKを追加した場合、この提出パッケージと `docs/` の法務文書を更新してください。

## 参照したApple公式情報

- Apple App Privacy Details: https://developer.apple.com/app-store/app-privacy-details/
- Apple App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
