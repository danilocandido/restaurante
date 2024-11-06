# Produtos
Product.find_or_create_by!(name: 'Panelada', price: 15.00, category: :prato)
Product.find_or_create_by!(name: 'Cajuína', price: 5.00, category: :bebida)

# Mesa
Table.find_or_create_by!(number: 1)
Table.find_or_create_by!(number: 2)
