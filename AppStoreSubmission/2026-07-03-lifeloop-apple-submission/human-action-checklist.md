# 人間が実施するApp Store申請作業

作成日: 2026-07-12
対象アプリ: lifeloop
提供者: Knock Knock 株式会社
Bundle ID: at.knockknock.lifeloop

このファイルは、Apple DeveloperアカウントまたはApp Store Connect上で人間の権限・判断が必要な作業だけをまとめたものです。転記元の文章は同じフォルダ内の各ファイルを使ってください。

## 1. Apple Developerアカウント確認

- [ ] Apple Developer Programの契約が有効であることを確認する。
- [ ] App Store Connectの利用規約、契約、税務、銀行情報に未処理の警告がないことを確認する。
- [ ] Knock Knock 株式会社としてレビュー対応できる電話番号とメールアドレスを用意する。

## 2. アプリレコード作成

- [ ] App Store Connectで新規アプリを作成する。
- [ ] Bundle IDに `at.knockknock.lifeloop` を選ぶ。
- [ ] アプリ名に `lifeloop` を入力する。
- [ ] SKUを入力する。例: `lifeloop-ios-001`
- [ ] プライマリカテゴリを `ライフスタイル` にする。
- [ ] セカンダリカテゴリを `仕事効率化` にする。

## 3. 商品ページ情報入力

- [ ] `app-store-connect-fields-ja.md` の内容をApp Store Connectへ転記する。
- [ ] Marketing URLに `https://www.knockknock.at/products/lifeloop` を入力する。
- [ ] Privacy Policy URLに `https://knockknock-at.github.io/lifeloop/docs/lifeloop/privacy.html` を入力する。
- [ ] Support URLに `https://knockknock-at.github.io/lifeloop/docs/lifeloop/support.html` を入力する。
- [ ] `AppStoreScreenshots/final/` の5枚を表示順どおりアップロードする。

## 4. App Privacy

- [ ] `app-privacy-answers.md` を見ながら、Data Collectedを `No` として回答する。
- [ ] Trackingを `No` として回答する。
- [ ] サーバー送信、アカウント、広告、分析SDK、第三者SDKを追加していないことを提出直前に再確認する。

## 5. 年齢レーティングとコンプライアンス

- [ ] 年齢レーティング質問に実装どおり回答する。
- [ ] 医療、服薬、緊急、安全管理用途ではないことを説明文・Review Notesと矛盾させない。
- [ ] 輸出コンプライアンス/暗号化質問は `export-compliance.md` を見ながら現行実装どおり回答する。

## 6. ビルド選択と審査提出

- [ ] Xcode OrganizerまたはTransporterでApp Store Connectへビルドをアップロードする。
- [ ] App Store Connectで処理済みビルドを選択する。
- [ ] Review Notesに `app-review-notes.txt` の内容を貼り付ける。
- [ ] デモアカウントは不要として提出する。
- [ ] App Review Contact Informationに実際に連絡を受けられる連絡先を入力する。
- [ ] 提出前に `pre-submission-checklist.md` を最後まで確認する。
