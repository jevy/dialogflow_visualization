require 'bundler/setup'
require 'ruby-graphviz'
require 'json'

class NodeTracker

  @@created_nodes = [""]

  def add_node_even_if_existing(g, node)
    if @@created_nodes.include?(node)
      g.add_nodes(node)
      @@created_nodes << node
    end
  end
end

intent_files = Dir["shared/InsuranceQuoteFull/intents/*"].delete_if {|f| f.match(/usersays/)}
node_tracker = NodeTracker.new

g = GraphViz.new( :G, :type => :digraph )

intent_files.each do |f|
  file = File.open(f)
  j = JSON.parse(file.read)
  file.close

  intent = j['name']
  input_contexts = j['contexts']
  output_contexts = j['responses'][0]['affectedContexts'].map{|e| e["name"]}

  if input_contexts.empty? then
    input_intent = "Default Start Intent"
    node_tracker.add_node_even_if_existing(g, input_intent)
  else
    input_contexts.each do |node|
      input_intent = node
      node_tracker.add_node_even_if_existing(g, node)
    end
  end

  first_question = j['responses'][0]['messages'][0]['speech']

  # Having a single input intent might not work if there are multiple
  output_contexts.each do |node|
    node_tracker.add_node_even_if_existing(g, node)
    g.add_edges(input_intent, node, label: "#{intent}\n#{first_question}")
  end

end

g.output( :png => "shared/conversation_path.png" )

