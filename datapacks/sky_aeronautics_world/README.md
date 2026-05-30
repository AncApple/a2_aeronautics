# Sky Aeronautics World — データパック

Create Aeronautics 向けの三層浮島ワールド生成設定です。  
Sky Archipelago mod の `sky_islands` ワールドプリセットを上書きします。

---

## 三層島分布の設計

| 層 | Y帯の目安 | 密度 | 移動手段 |
|----|----------|------|----------|
| 近距離層 | Y 64〜160 (low_band, 55%) | 高 | 徒歩・橋・Elytra |
| 中距離層 | Y 160〜260 (mid_high_band, 35%) | 中 | Elytra + Hot Air Balloon |
| 遠距離/高高度層 | Y 260〜320 (very_high_band, 10%) | 低 | Aeronautics 飛行船が事実上必須 |

- 島サイズ: 小(r20-42, 40%) / 中(r42-68, 45%) / 大(r75-110, 15%)
- 島の厚さ: 最大 60 ブロック（内部に鉱石・洞窟が生成される）
- 海: 無効（虚空のみ）— `forgiving_void` Mod が虚空落下死を防ぎます

---

## 依存 Mod（全てパックに導入済み）

| Mod | 役割 |
|-----|------|
| `sky_archipelago-1.3.3.jar` | 浮島ジェネレータ本体（必須） |
| `terralith` | バイオーム多様化（自動適用） |
| `forgiving_void` | 虚空落下死防止 |
| `create-aeronautics` | 飛行船システム |

**Continents は Sky Archipelago と地形生成レベルで非互換**です（Sky Archipelago は独自ジェネレータを使うため、Continents の noise router 上書きは地形に影響しません）。Continents はパックに含まれていますが、sky_islands ワールドタイプを選択した場合は地形には無効です。

---

## 適用手順

### サーバーの場合

```
server/
└── world/
    └── datapacks/
        └── sky_aeronautics_world/   ← このフォルダごとコピー
            ├── pack.mcmeta
            └── data/
```

1. `datapacks/sky_aeronautics_world/` フォルダを `world/datapacks/` にコピー
2. **新規ワールド作成時**に「Sky Islands」ワールドタイプを選択する（既存ワールドには適用不可）
3. サーバー起動後 `datapack list` で `[sky_aeronautics_world]` が表示されることを確認

### クライアント（シングルプレイ）の場合

1. Minecraft を起動し、「新しいワールドを作成」→「その他のオプション」→「データパック」
2. `sky_aeronautics_world` フォルダをドラッグ＆ドロップして有効化
3. 「ワールドタイプ」で「Sky Islands」を選択してワールドを作成

### 読み込み順（重要）

```
優先度 高 → 低
sky_aeronautics_world   ← sky_islands.json を上書き
sky_archipelago (jar)   ← デフォルト値のフォールバック
terralith (jar)         ← バイオーム定義をインジェクト
```

他のワールドジェン系データパックと競合する場合は `sky_aeronautics_world` を最上位に配置してください。

---

## 設定値の調整早見表

変更したいとき → 触るファイル: `data/sky_archipelago/worldgen/world_preset/sky_islands.json`

| 変えたいもの | キー | 現在値 | 調整方向 |
|-------------|------|--------|---------|
| 全体の島密度 | `terrain.island_density` | `0.45` | 増やすと密、減らすと疎。0.3〜0.6 が実用範囲 |
| 序盤島の割合 | `terrain.low_band_weight` | `0.55` | 増やすと低高度の島が多くなる |
| 中距離島の割合 | `terrain.mid_high_band_weight` | `0.35` | 調整 |
| 終盤高高度島の割合 | `terrain.very_high_band_weight` | `0.10` | 増やすと終盤島が増える |
| 島のY最低高度 | `terrain.min_island_y` | `64` | 下げると初期スポーンが危険になる可能性あり |
| 島のY最高高度 | `terrain.max_island_y` | `320` | ビルド高度上限(320)以下に収めること |
| 島の最大厚さ | `terrain.max_island_thickness_blocks` | `60` | 増やすと島が分厚くなり鉱石が出やすい |
| 島間距離の最小 | `terrain.min_cluster_spacing` | `96` | 序盤が難しいなら減らす |
| 島間距離の最大 | `terrain.max_cluster_spacing` | `480` | 増やすと遠い島がさらに遠くなる |
| 構造物の生成厳しさ | `structure_support.support_threshold` | `0.40` | 上げると虚空際の構造物が減る（0.6が最大推奨） |

**三項目のband_weightの合計を常に 1.0 にすること。**

---

## プリセット文字列の共有（4人で同一設定を再現する方法）

1. ゲーム内で OP 権限を持つプレイヤーが `/skyarchipelago preset export` を実行
2. 表示された JSON テキストをコピーして全員に共有
3. 受け取ったプレイヤーはそのテキストを `/skyarchipelago preset import <テキスト>` で読み込む

※ このデータパック自体を全員の `world/datapacks/` に配置している場合、
  `sky_islands.json` が直接ワールド設定を上書きするためコマンドは不要です。

サーバー環境では `sky_islands.json` の上書きが最も確実な設定共有方法です。

---

## サバイバル整合: 既知課題と対応

### 水源
- Sky Archipelago は各バイオームの地表生成（川・湖など）を保持するため、
  多くの島に自然な水源が生成されます
- Create mod の Spout + 水入りバケツ または Mechanical Pump で水を移送できます
- 初期島に水源がない場合: 雨水バレル系 mod またはネザーのソウルサンド + 水をいくつか集める

### ネザー到達
- Ruined Portal が islands 上に自然生成されます（`support_threshold: 0.40` で確保）
- 玄武岩デルタ島など溶岩が自然生成されるバイオームも出現
- 黒曜石は Create の Fluid Pipe で溶岩と水を合わせて作成可能

### ストロングホールド（エンドアクセス）
Sky Archipelago のストロングホールドは「島のテレイン内部」に生成されます。
島の厚さが 60 ブロックあるため、大型島（radius 75-110）であれば内部に収まります。
`/locate structure minecraft:stronghold` で位置を確認してください。
見つからない場合は `structure_support.support_threshold` を `0.25` まで下げてリトライしてください
（**新規ワールドでないと反映されません**）。

### スポーン地点
Sky Archipelago は起動時に安全な島の上にスポーン地点を設定します。
虚空上や海上に立つことはありません（`forgiving_void` が追加の保護を提供）。

### モブスポーンキャップ
浮島は陸地面積が狭いためモブが密集しやすいです。
サーバー `server.properties` で以下を調整することを推奨:
```
max-entity-cramming=24
```
または `spawnMobs=false` にしてから `/difficulty peaceful` で序盤を始める選択肢もあります。

---

## 検証手順

### JSON構文チェック
```bash
python3 -m json.tool data/sky_archipelago/worldgen/world_preset/sky_islands.json > /dev/null
```

### ワールド生成テスト
1. テストワールドを「Sky Islands」タイプで作成
2. `/gamemode creative` で F3 を見ながら広域を飛行
3. 確認項目:
   - Y=64-180 帯に島が高密度で存在すること (near layer)
   - Y=180-260 帯に中程度の島があること (mid layer)
   - Y=260+ に少数の孤立した大型島があること (far layer)
   - 虚空に構造物が浮いていないこと
   - 村・廃坑・要塞が島の上または内部に生成されていること
4. `/locatebiome minecraft:plains` 等で Terralith バイオームが適用されていることを確認

### 起動ログの確認
NeoForge サーバー起動後、ログに以下のような行がないことを確認:
```
[ERROR] Failed to load data pack
[WARN]  Unknown key in sky_island_settings
```
