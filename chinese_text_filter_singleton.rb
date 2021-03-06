# encoding: utf-8

require 'singleton'
require 'rmmseg'

#for ruby1.9

MEANINGLESS = %w(的 得 地)

class Chinese_text_filter
  include Singleton

  def initialize
    RMMSeg::Dictionary.load_dictionaries
  end

  def segment(text)
    algor = RMMSeg::Algorithm.new(text)
    words = String.new.force_encoding("utf-8")

    loop do
      tok = algor.next_token
      break if tok.nil?
      words << tok.text << " "
    end

    words
  end

  def remove_punctuation(text) 
    words = String.new.force_encoding("utf-8")
    #words = text.gsub(/，|。|：/, '').squeeze;
    words = text.gsub(/\u3002|\uFF0C|\uFF1A/, '').squeeze
  end

  def remove_meaningless_words(text)
    words = text.split

    new_words = String.new.force_encoding("utf-8")

    words.each do |word|
      unless MEANINGLESS.include?(word)
        new_words << word << " " 
      end
    end

    new_words
  end

  def convert_to_hashes(text)
    words = text.split
    dic = Hash.new

    words.each do |word|
      if dic.member?(word)
        dic[word] = dic[word] + 1
      else
        dic[word] = 1
      end
    end

    dic.sort_by {|k, v| v}.reverse
  end

end


text = "知名程序员 Ken Thompson 说：想发现有天赋的程序员，重点在激情，在谈话的过程中你会感受到这种激情有多少。我会问他做过最有趣的程序是什么，然后让他描述该程序的细节。如果经不起我的盘问，或者是发现算法和解决方案有问题，而他不能解释清楚，或不能比我做得更投入，那么他也不是好的程序员。"

text.force_encoding("utf-8")

text1 = Chinese_text_filter.instance.segment(text)
text1.force_encoding("utf-8")
puts text1

text2 = Chinese_text_filter.instance.remove_punctuation(text1)
text2.force_encoding("utf-8")
puts text2

text3 = Chinese_text_filter.instance.remove_meaningless_words(text2)
text3.force_encoding("utf-8")
puts text3

hash = Chinese_text_filter.instance.convert_to_hashes(text3)
hash.each do |key, value|
  puts "#{key}:#{value}"
end
