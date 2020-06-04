# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kakebosan,
  ecto_repos: [Kakebosan.Repo]

# Configures the endpoint
config :kakebosan, KakebosanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Je2OD3paVW4OtqJc5UEMb1/umR71dDfLvZZFGgm3JtESInJi8aaYncsdjh7+h3+d",
  render_errors: [view: KakebosanWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kakebosan.PubSub,
  live_view: [signing_salt: "I6RQblju"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile openid"]}
  ]

# read client ID/secret from the environment variables in the run time
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: {System, :get_env, ["GOOGLE_CLIENT_ID"]},
  client_secret: {System, :get_env, ["GOOGLE_CLIENT_SECRET"]}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# アカウント作成時の初期勘定科目
config :kakebosan, :item_seeds,
  assets: [
    %{name: "現金", description: "現金として所持している金額を表す科目"},
    %{name: "普通預金1", description: "普通預金口座を表す科目。金融機関、口座別の科目を作成するのがオススメ"},
    %{name: "普通預金2", description: "普通預金口座を表す科目。金融機関、口座別の科目を作成するのがオススメ"},
    %{name: "普通預金3", description: "普通預金口座を表す科目。金融機関、口座別の科目を作成するのがオススメ"},
    %{name: "電子マネー1", description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ"},
    %{name: "電子マネー2", description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ"},
    %{name: "電子マネー3", description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ"},
    %{name: "電子マネー4", description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ"},
    %{name: "電子マネー5", description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ"},
    %{name: "ポイント1", description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ"},
    %{name: "ポイント2", description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ"},
    %{name: "ポイント3", description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ"},
    %{name: "ポイント4", description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ"},
    %{name: "ポイント5", description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ"}
  ],
  expenses: [
    %{name: "食費", description: "生活必需品のうち食料品"},
    %{name: "外食費", description: "外食の費用。場合によっては食費、もしくは遊興費として取り扱ってもよいかもしれない"},
    %{name: "日用品", description: "洗剤等。生活必需品のうち、主に食料品以外"},
    %{name: "遊興費", description: "レジャー、趣味、飲み会など"},
    %{name: "住宅費", description: "家賃、ローン返済など"},
    %{name: "電気料金", description: ""},
    %{name: "ガス料金", description: ""},
    %{name: "水道料金", description: ""},
    %{name: "通信費", description: "電話、インターネット、郵便料金など"},
    %{name: "交通費", description: ""},
    %{name: "医療費", description: ""},
    %{name: "被服費", description: "服、靴の購入費用、クリーニング代など"},
    %{name: "教育費", description: "書籍、学費、塾など"},
    %{name: "交際費", description: "祝儀・お見舞い・慶弔費（香典など）・会食代など"},
    %{name: "生命保険・医療保険", description: ""},
    %{name: "自動車保険", description: ""},
    %{name: "健康保険", description: ""},
    %{name: "国民年金・厚生年金・共済年金", description: ""},
    %{name: "雇用保険", description: ""},
    %{name: "所得税", description: ""},
    %{name: "住民税", description: ""},
    %{name: "固定資産税", description: ""},
    %{name: "手数料", description: "取引に伴う手数料など"},
    %{name: "棚卸差額", description: "棚卸し時に判明した差額"},
    %{name: "その他費用", description: ""}
  ],
  liabilities: [
    %{name: "カード決済1", description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される"},
    %{name: "カード決済2", description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される"},
    %{name: "カード決済3", description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される"},
    %{name: "カード決済4", description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される"},
    %{name: "カード決済5", description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される"},
    %{name: "借金", description: "借金の額を表す科目。借金返済次に打ち消される"}
  ],
  net_assets: [],
  revenues: [
    %{name: "給与収入", description: ""},
    %{name: "ポイント発生", description: ""},
    %{name: "その他雑収入", description: ""}
  ]
