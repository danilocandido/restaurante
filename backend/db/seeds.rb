# Produtos
Product.find_or_create_by!(name: 'Panelada', price: 15.00, category: :prato)
Product.find_or_create_by!(name: 'Cajuína', price: 5.00, category: :bebida)
Product.find_or_create_by!(name: 'Feijoada', price: 15.00, category: :prato)

# Mesa
Table.find_or_create_by!(number: 10)
Table.find_or_create_by!(number: 20)
Table.find_or_create_by!(number: 30)
