# encoding: utf-8
require 'redis'
require 'ostruct'
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../Tinto/Member'
require_relative '../../Tinto/Exceptions'

$redis = Redis.new
$redis.select 8

describe Tinto::Member do
  before do 
    $redis.flushdb 
  end

  describe '#initialize' do
    it 'retrieves the resource from DB if resource has an id' do
      persisted = fake_resource('name' => 'resource 1')
      record    = Tinto::Member.new(persisted).save
      resource  = OpenStruct.new(id: record.id, storage_key: 'resource')


      Tinto::Member.new(resource).resource.attributes
        .must_equal persisted.attributes
    end
  end
  
  describe '#==' do
    it 'compares based on the #attributes value' do
      resource1 = fake_resource('name' => 'resource 1')
      resource2 = fake_resource('name' => 'resource 1')

      record1   = Tinto::Member.new(resource1)
      record2   = Tinto::Member.new(resource2)

      (record1 == resource2).must_equal true
    end
  end

  describe '#score' do
    it 'returns the integer value of the updated_at attribute' do
      resource  = fake_resource('name' => 'resource 1')
      record    = Tinto::Member.new(resource)
      record.save

      (record.score > 0).must_equal true
    end

    it 'returns 0 if resource has no updated_at attribute' do
      resource  = fake_resource('name' => 'resource 1')
      record    = Tinto::Member.new(resource)
      
      record.score.must_equal 0
    end
  end

  describe '#to_json' do
    it 'returns a JSON serialization of the resource attributes' do
      resource  = fake_resource('name' => 'resource 1')
      record    = Tinto::Member.new(resource)

      record.to_json.must_equal({name: 'resource 1' }.to_json)
    end
  end

  describe '#read' do
    it 'returns the persisted record instance' do
      persisted = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(persisted).save
      resource  = OpenStruct.new(id: record.id, storage_key: 'resource')
      record2   = Tinto::Member.new(resource)

      record2.read.attributes.must_equal persisted.attributes
    end
  end

  describe '#save' do
    it 'assigns an id if user is not persisted' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)

      record.resource.id.must_be_nil
      record.save
      record.resource.id.wont_be_nil
    end

    it 'returns the persisted record instance' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)

      record.resource.id.must_be_nil
      record.save.must_be_instance_of OpenStruct
    end

    it 'raises InvalidResource if resource not valid' do
      resource  = fake_resource('name' => 'resource')
      def resource.valid?; false; end
      record    = Tinto::Member.new(resource)

      lambda { record.save }.must_raise Tinto::Exceptions::InvalidResource
    end
  end

  describe '#update' do
    it 'merges non-protected attributes and saves the resource' do
      skip
      resource  = fake_resource('name' => 'resource')
      def resource.name=(text); attributes['name'] = text; end

      record = Tinto::Member.new(resource)
      record.save

      changed = OpenStruct.new(
                  name:       'changed resource',
                  attributes: OpenStruct.new(name: 'changed resource' )
                )
      record.update(changed)

      resource.attributes['name'].must_equal 'changed resource'
    end

  end #update

  describe '#delete' do
    it 'marks the record as deleted' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)

      record.save
      record.resource.deleted_at.must_be_nil
      record.delete
      record.resource.deleted_at.wont_be_nil
    end

    it 'returns the persisted record instance' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)
      record.save

      record.delete.must_be_instance_of OpenStruct
    end

    it 'raises an exception unless resource was already persisted' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)

      lambda { record.delete }.must_raise Tinto::Exceptions::InvalidResource
    end
  end

  describe '#undelete' do
    it 'clears the deleted_at attribute' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)

      record.save
      record.resource.created_at.wont_be_nil
      
      record.delete
      record.resource.deleted_at.wont_be_nil

      record.undelete
      record.resource.deleted_at.must_be_nil
    end

    it 'returns the undeleted member' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)

      record.save
      record.resource.created_at.wont_be_nil
      
      record.delete

      result = record.undelete
      result.class.must_equal resource.class
    end

    it 'raises an exception unless resource is not deleted' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)

      record.save
      record.resource.deleted_at.must_be_nil

      lambda { record.undelete }.must_raise Tinto::Exceptions::InvalidResource
    end
  end

  describe '#destroy' do
    it 'removes a previously deleted record from the database' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)
      record.save

      $redis.get(record.send :id_key).wont_be_nil
      record.delete
      record.destroy
      $redis.get(record.send :id_key).must_be_nil
    end

    it 'returns the resource with a nil id attribute' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)
      record.save

      resource.id.wont_be_nil
      record.delete
      record.destroy
      resource.id.must_be_nil
      resource.name.must_equal resource.name
    end

    it 'raises an exception unless resource is not deleted' do
      resource  = fake_resource('name' => 'resource')
      record    = Tinto::Member.new(resource)
      record.save

      lambda { record.destroy }.must_raise Tinto::Exceptions::InvalidResource
    end
  end
   
  def fake_resource(attrs={})
    persisted = OpenStruct.new(
      attributes: attrs,
      storage_key: 'resource'
    )
    def persisted.valid?; true ; end
    persisted
  end
end # Tinto::Member
