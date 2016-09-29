class Analytics

	def post_data		
		Post.all.map do |post|
			data = {}

			metadata = {
				post_id: 							post.id,
				word_count:           post.body.scan(/\w+/).count,
				average_word_length:  average_word_length(post.body), 
				most_common_words:    most_common_words(post.body)
			}

			data[:metadata] = metadata

			post.attributes.update(data)
		end
	end

	def blog_data
		analytics = []
		blog_data = {
			entries: 					 				 Post.all.count,
			most_recent_entry_id: 		 Post.last.id,
			blog_average_word_length:  blog_average("average_word_length"),
			blog_average_word_count: 	 blog_average("word_count"),
			longest_entry:  					 longest_entry 
		}					
	end


	private 
	 	def average_word_length(text)
	 		(text.split.join.length.to_f / text.scan(/\w+/).count).round
	 	end

	 	def blog_average(argument)
	 		argument_array = post_data.map{ |post| post[:metadata][argument.to_sym]}
	 		argument_array.sum / argument_array.length
	 	end

	 	def longest_entry 
	 		longest_entry = post_data.group_by { |post| post[:metadata][:word_count] }.max
	 		{ post_id: longest_entry[1].first["id"], length: longest_entry.first} 
	 	end

	 	def most_common_words(text)
	 		each_word = text.downcase.scan(/\w+/)
	 		word_frequency_array = Hash.new(0).tap { |hash| each_word.each { |word| has[word] += 1 } }

	 		max_frequency 		= word_frequency_array.values.max
	 		most_common_words = word_frequency_array.select { |k, v| v == max_frequency }.keys 

	 		most_common_words.push({ "frequency" => max_frequency })
	 	end	
end