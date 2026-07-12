# 提出前チェックリスト

作成日: 2026-07-03
更新日: 2026-07-12
対象アプリ: lifeloop
提供者: Knock Knock 株式会社

## 公開ページ

- [ ] `https://www.knockknock.at/products/lifeloop` がログインなしで開ける。
- [ ] `https://knockknock-at.github.io/lifeloop/docs/` がログインなしで開ける。
- [ ] `https://knockknock-at.github.io/lifeloop/docs/lifeloop/privacy.html` がログインなしで開ける。
- [ ] `https://knockknock-at.github.io/lifeloop/docs/lifeloop/support.html` がログインなしで開ける。
- [ ] `https://knockknock-at.github.io/lifeloop/docs/lifeloop/terms.html` がログインなしで開ける。
- [ ] 商品ページからlifeloopの説明、プライバシー、サポート情報へログインなしで到達できる。
- [ ] 公開ページ内の提供者が `Knock Knock 株式会社` になっている。
- [ ] 問い合わせ先が `https://github.com/knockknock-at/lifeloop/issues` になっている。

## App Store Connect

- [ ] Marketing URLに `https://www.knockknock.at/products/lifeloop` を入力した。
- [ ] Privacy Policy URLに `https://knockknock-at.github.io/lifeloop/docs/lifeloop/privacy.html` を入力した。
- [ ] Support URLに `https://knockknock-at.github.io/lifeloop/docs/lifeloop/support.html` を入力した。
- [ ] `AppStoreScreenshots/final/` の5枚を表示順どおりアップロードした。
- [ ] App Privacy回答を現行実装と照合した。
- [ ] 年齢レーティング質問に実装どおり回答した。
- [ ] 輸出コンプライアンス/暗号化質問に現行実装どおり回答した。
- [ ] Review Notesに `app-review-notes.txt` の内容を貼り付けた。
- [ ] デモアカウント不要として提出した。
- [ ] App Review Contact InformationにKnock Knock 株式会社として対応できる連絡先を入力した。
- [ ] スクリーンショットが実際の画面を示している。
- [ ] 商品ページ説明が、医療、服薬、緊急、安全管理用途を示唆していない。

## アプリ実装

- [ ] 実機で起動確認した。
- [ ] 位置情報許可の説明が表示される。
- [ ] 通知許可の説明が表示される。
- [ ] Placeを登録できる。
- [ ] Place画面の左スワイプ「テスト」でローカル通知を出せる。
- [ ] 通知を開くとLog画面へ遷移する。
- [ ] アカウント登録なしで主要機能を確認できる。
- [ ] 位置情報、Place、Act、Course、Step、Logをサーバーへ送信していない。

## 注意して見る項目

- [ ] `PRODUCT_BUNDLE_IDENTIFIER` が `at.knockknock.lifeloop` で、App Store ConnectのBundle IDと一致している。
- [ ] 販売元/提供者名がKnock Knock 株式会社の実態と一致している。
- [ ] App Privacyの `Data Collected: No` が現行実装と矛盾していない。
- [ ] Appleから追加説明を求められた場合は、`location-and-notification-explanation.md` をもとに回答する。
