# 提出前チェックリスト

作成日: 2026-07-03
対象アプリ: lifeloop
提供者: Knock Knock 株式会社

## 公開ページ

- [ ] `docs/` の内容を `https://www.knockknock.at/` 配下に配置した。
- [ ] `https://www.knockknock.at/lifeloop/privacy.html` がログインなしで開ける。
- [ ] `https://www.knockknock.at/lifeloop/support.html` がログインなしで開ける。
- [ ] `https://www.knockknock.at/lifeloop/terms.html` がログインなしで開ける。
- [ ] 公開ページ内の提供者が `Knock Knock 株式会社` になっている。
- [ ] 問い合わせ先が `https://github.com/ganase/lifeloop/issues` になっている。

## App Store Connect

- [ ] Privacy Policy URLに `https://www.knockknock.at/lifeloop/privacy.html` を入力した。
- [ ] Support URLに `https://www.knockknock.at/lifeloop/support.html` を入力した。
- [ ] App Privacy回答を現行実装と照合した。
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

- [ ] `PRODUCT_BUNDLE_IDENTIFIER` がApp Store ConnectのBundle IDと一致している。
- [ ] 販売元/提供者名がKnock Knock 株式会社の実態と一致している。
- [ ] App Privacyの `Data Collected: No` が現行実装と矛盾していない。
- [ ] Appleから追加説明を求められた場合は、`location-and-notification-explanation.md` をもとに回答する。
