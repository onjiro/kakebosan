defmodule KakebosanWeb.Accounting.Item do
  use Kakebosan.Web, :model
  alias KakebosanWeb.Accounting.Item
  alias KakebosanWeb.Accounting

  schema "accounting_items" do
    field :name, :string
    field :description, :string
    field :selectable, :boolean, default: false
    belongs_to :user, KakebosanWeb.User
    belongs_to :type, KakebosanWeb.Accounting.Type

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :selectable, :user_id, :type_id])
    |> validate_required([:name])
  end

  @doc"""
  Calculate inventory from passed items
  """
  @spec inventories(Ecto.Queryable, DateTime) :: EctoQueryable
  def inventories(query, date) do
    from item in query,
      join: type in Accounting.Type, where: type.id == item.type_id,
      left_join: entry in Accounting.Entry, where: entry.item_id == item.id,
      left_join: trx in Accounting.Transaction, where: trx.id == entry.transaction_id,
      where: trx.date <= ^date,
      group_by: item.id,
      select: %Accounting.Inventory{ item_id: item.id,
                                     amount: fragment("COALESCE(SUM(CASE WHEN ? THEN ? ELSE - ? END), 0)",
                                       entry.side_id == type.side_id,
                                       entry.amount,
                                       entry.amount) }
  end

  @doc"""
  Calculate amount summary by items
  """
  def summaries(query, date_from, date_to) do
    from item in query,
      join: type in Accounting.Type, on: type.id == item.type_id,
      preload: [type: type],
      left_join: entry in Accounting.Entry, on: entry.item_id == item.id,
      left_join: trx in Accounting.Transaction, on: trx.id == entry.transaction_id,
      left_join: side in Accounting.Side, on: entry.side_id == side.id,
      where: trx.date >= ^date_from,
      where: trx.date <= ^date_to,
      group_by: [item.id, type.side_id, type.id],
      order_by: [type.side_id, type.id],
      select: %{ item: item,
                 type: type,
                 debit_amount: fragment("COALESCE(SUM(CASE WHEN ? THEN ? ELSE 0 END), 0)",
                   side.name == "借方",
                   entry.amount),
                 credit_amount: fragment("COALESCE(SUM(CASE WHEN ? THEN ? ELSE 0 END), 0)",
                   side.name == "貸方",
                   entry.amount),
                 amount_grow: fragment("COALESCE(SUM(CASE WHEN ? THEN ? ELSE ? END), 0)",
                   entry.side_id == type.side_id,
                   entry.amount,
                   entry.amount * -1) }
  end

  @doc """
  ユーザー登録時の初期科目セットを登録する
  """
  def create_initial_items(user) do
    # 資産 - Account
    sources = %{ 1 => [ %{ name: "現金"                         , description: "現金として所持している金額を表す科目" },
                        %{ name: "普通預金1"                    , description: "普通預金口座を表す科目。金融機関、口座別の科目を作成するのがオススメ" },
                        %{ name: "普通預金2"                    , description: "普通預金口座を表す科目。金融機関、口座別の科目を作成するのがオススメ" },
                        %{ name: "普通預金3"                    , description: "普通預金口座を表す科目。金融機関、口座別の科目を作成するのがオススメ" },
                        %{ name: "電子マネー1"                  , description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ" },
                        %{ name: "電子マネー2"                  , description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ" },
                        %{ name: "電子マネー3"                  , description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ" },
                        %{ name: "電子マネー4"                  , description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ" },
                        %{ name: "電子マネー5"                  , description: "電子マネー等を表す科目。種類別の科目を作成するのがオススメ" },
                        %{ name: "ポイント1"                    , description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ" },
                        %{ name: "ポイント2"                    , description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ" },
                        %{ name: "ポイント3"                    , description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ" },
                        %{ name: "ポイント4"                    , description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ" },
                        %{ name: "ポイント5"                    , description: "各店舗のポイントを表す科目。店舗別に作成するのがオススメ" } ],
                 # 費用 - Expense
                 2 => [ %{ name: "食費"                         , description: "生活必需品のうち食料品" },
                        %{ name: "外食費"                       , description: "外食の費用。場合によっては食費、もしくは遊興費として取り扱ってもよいかもしれない" },
                        %{ name: "日用品"                       , description: "洗剤等。生活必需品のうち、主に食料品以外" },
                        %{ name: "遊興費"                       , description: "レジャー、趣味、飲み会など" },
                        %{ name: "住宅費"                       , description: "家賃、ローン返済など" },
                        %{ name: "電気料金"                     , description: "" },
                        %{ name: "ガス料金"                     , description: "" },
                        %{ name: "水道料金"                     , description: "" },
                        %{ name: "通信費"                       , description: "電話、インターネット、郵便料金など" },
                        %{ name: "交通費"                       , description: "" },
                        %{ name: "医療費"                       , description: "" },
                        %{ name: "被服費"                       , description: "服、靴の購入費用、クリーニング代など" },
                        %{ name: "教育費"                       , description: "書籍、学費、塾など" },
                        %{ name: "交際費"                       , description: "祝儀・お見舞い・慶弔費（香典など）・会食代など" },
                        %{ name: "生命保険・医療保険"           , description: "" },
                        %{ name: "自動車保険"                   , description: "" },
                        %{ name: "健康保険"                     , description: "" },
                        %{ name: "国民年金・厚生年金・共済年金" , description: "" },
                        %{ name: "雇用保険"                     , description: "" },
                        %{ name: "所得税"                       , description: "" },
                        %{ name: "住民税"                       , description: "" },
                        %{ name: "固定資産税"                   , description: "" },
                        %{ name: "手数料"                       , description: "取引に伴う手数料など" },
                        %{ name: "棚卸差額"                     , description: "棚卸し時に判明した差額" },
                        %{ name: "その他費用"                   , description: "" } ],
                 # 負債 - Liability
                 3 => [ %{ name: "カード決済1"                  , description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される" },
                        %{ name: "カード決済2"                  , description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される" },
                        %{ name: "カード決済3"                  , description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される" },
                        %{ name: "カード決済4"                  , description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される" },
                        %{ name: "カード決済5"                  , description: "口座振替前のカード決済額を表す科目。口座振替完了時に打ち消される" },
                        %{ name: "借金"                         , description: "借金の額を表す科目。借金返済次に打ち消される" } ],
                 # 資本 - Capital
                 4 => [],
                 # 収益 - Income
                 5 => [ %{ name: "給与収入"                     , description: "" },
                        %{ name: "ポイント発生"                 , description: "" },
                        %{ name: "その他雑収入"                 , description: "" } ]
    }
    for {type_id, items} <- sources do
      for item <- items do
        Kakebosan.Repo.insert(Item.changeset(%KakebosanWeb.Accounting.Item{user: user, type_id: type_id},
              item
              |> Map.put(:type_id, type_id) ))
      end
    end
  end
end
