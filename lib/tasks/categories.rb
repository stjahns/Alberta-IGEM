origins = Category.find_or_create_by_name("Origins")
origins.update_attributes(:description => "Origins of replication")

promoters = Category.find_or_create_by_name("Promoters")
promoters.update_attributes(:description => "Promote transcription of a downstream open reading frame")

reporters = Category.find_or_create_by_name("Reporter Genes")
reporters.update_attributes(:description => "Open reading frames that produce a detectable product")

markers = Category.find_or_create_by_name("Selectable Markers")
markers.update_attributes(:description => "Selectable markers include antibiotic resistance genes that enable efficient screening by selection")

other = Category.find_or_create_by_name("Other")
other.update_attributes(:description => "Any other sorts of parts")

#set all uncategorized bytes to 'other'

BioByte.all.each do |b|
  if b.category.blank?
    b.category = Category.find_by_name("Other")
    b.save
    puts "hello!"
  end
end
