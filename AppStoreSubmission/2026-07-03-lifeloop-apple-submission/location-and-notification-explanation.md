# 位置情報・通知利用目的

作成日: 2026-07-03
対象アプリ: lifeloop
提供者: Knock Knock 株式会社

## App Review向け説明

lifeloopは、利用者が登録したPlaceへの到着・離脱をきっかけに、その場所で取り組みたいActをローカル通知するアプリです。

位置情報は次の目的に限定して使用します。

- 現在地からPlaceを登録するため
- アプリ内地図で現在地と登録Placeを表示するため
- iOSのRegion Monitoringにより、登録Placeへの到着・離脱を判定するため
- 登録Placeに紐づくStepを照合し、端末内のローカル通知を表示するため

通知は次の目的に限定して使用します。

- 登録Placeへの到着・離脱時に該当するActを知らせるため
- 利用者が指定したスヌーズ時刻に同じStepを再通知するため

## Info.plistの位置情報説明

`NSLocationWhenInUseUsageDescription`

```text
現在地から場所を登録し、登録地点の近くで通知を出すために位置情報を使用します。
```

`NSLocationAlwaysAndWhenInUseUsageDescription`

```text
登録した場所に近づいたり到着したりしたとき、生活習慣の行動通知を出すために位置情報を使用します。
```

`NSLocationAlwaysUsageDescription`

```text
登録した場所に到着したとき、バックグラウンドでも生活習慣の通知を出すために位置情報を使用します。
```

## 注意事項

- lifeloopは、位置情報を緊急通報、医療、服薬、安全管理、運転支援に使用しません。
- 位置情報や通知の挙動は、iOS、端末設定、バッテリー状態、位置情報精度、Region Monitoringの制約により遅延・欠落・誤判定が発生することがあります。
- 位置情報を「常に許可」にしない場合、アプリを閉じている間の到着通知は動作しないことがあります。
