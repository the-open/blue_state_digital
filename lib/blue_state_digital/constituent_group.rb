require 'builder'
require 'nokogiri'
require_relative 'api_data_model'

module BlueStateDigital
  class ConstituentGroup < ApiDataModel
    attr_accessor :id, :name, :slug, :description, :group_type, :create_dt
    
    def self.create(attrs = {})
      cons_group = ConstituentGroup.new(attrs)
      xml = BlueStateDigital::Connection.perform_request '/cons_group/add_constituent_groups', {}, "POST", cons_group.to_xml
      doc = Nokogiri::XML(xml)
      cons_group.id = doc.xpath('//cons_group').first[:id]
      cons_group
    end
    
    def to_xml
      builder = Builder::XmlMarkup.new
      builder.instruct! :xml, version: '1.0', encoding: 'utf-8'
      builder.api do |api|
        api.cons_group do |cons_group|
          cons_group.name(@name) unless @name.nil?
          cons_group.slug(@slug) unless @slug.nil?
          cons_group.description(@description) unless @description.nil?
          cons_group.group_type(@group_type) unless @group_type.nil?
          cons_group.create_dt(@create_dt) unless @create_dt.nil?
        end
      end
    end
  end
end