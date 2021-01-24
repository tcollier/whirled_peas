require 'whirled_peas/settings/box_settings'
require 'whirled_peas/settings/grid_settings'
require 'whirled_peas/settings/text_settings'
require 'whirled_peas/template/box_element'
require 'whirled_peas/template/composer'
require 'whirled_peas/template/grid_element'
require 'whirled_peas/template/text_element'

module WhirledPeas
  module Template
    RSpec.describe Composer do
      describe '.next_name' do
        it 'returns a unique value each time' do
          names = Set.new
          100.times { names << described_class.next_name }
          expect(names.length).to eq(100)
        end
      end

      describe '#add_text' do
        subject(:composer) { described_class.new(parent) }

        let(:parent) { BoxElement.new('Parent', parent_settings) }
        let(:parent_settings) { Settings::BoxSettings.new }

        it 'adds a TextElement as the child of the composed element' do
          composer.add_text('Child') { 'the-content' }
          expect(parent.num_children).to eq(1)
          parent.each_child do |child|
            expect(child).to be_a(TextElement)
            expect(child.content).to eq('the-content')
          end
        end

        it 'yields the merged TextSettings' do
          yielded_settings = nil
          composer.add_text('Child') do |_, settings|
            yielded_settings = settings
            'the-content'
          end
          expect(yielded_settings).to be_a(Settings::TextSettings)
        end
      end

      describe '#add_box' do
        subject(:composer) { described_class.new(parent) }

        let(:parent) { BoxElement.new('Parent', parent_settings) }
        let(:parent_settings) { Settings::BoxSettings.new }

        it 'adds a BoxElement as the child of the composed element' do
          composer.add_box('Child') { 'the-content' }
          expect(parent.num_children).to eq(1)
          parent.each_child do |child|
            expect(child).to be_a(BoxElement)
          end
        end

        it 'yields a new Composer and the merged BoxSettings' do
          yielded_composer = nil
          yielded_settings = nil
          composer.add_box('Child') do |child_composer, settings|
            yielded_composer = child_composer
            yielded_settings = settings
          end
          expect(yielded_composer).to be_a(Composer)
          parent.each_child do |child|
            expect(yielded_composer.element).to eq(child)
          end
          expect(yielded_settings).to be_a(Settings::BoxSettings)
        end

        context 'with an element expliclitly added to the child composer' do
          it 'does not add another child' do
            composer.add_box('Child') do |child|
              child.add_text { 'explicit-content' }
              'implicit-content'
            end
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextElement)
                expect(grand_child.content).to eq('explicit-content')
              end
            end
          end
        end

        context 'with nothing expliclitly added to the child composer' do
          it 'adds the text returned from the block as a TextElement to the child' do
            composer.add_box('Child') { 'implicit-content' }
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextElement)
                expect(grand_child.name).to eq('Child-Text')
                expect(grand_child.content).to eq('implicit-content')
              end
            end
          end
        end
      end

      describe '#add_grid' do
        subject(:composer) { described_class.new(parent) }

        let(:parent) { GridElement.new('Parent', parent_settings) }
        let(:parent_settings) { Settings::GridSettings.new }

        it 'adds a GridElement as the child of the composed element' do
          composer.add_grid('Child') { 'the-content' }
          expect(parent.num_children).to eq(1)
          parent.each_child do |child|
            expect(child).to be_a(GridElement)
          end
        end

        it 'yields a new Composer and the merged GridSettings' do
          yielded_composer = nil
          yielded_settings = nil
          composer.add_grid('Child') do |child_composer, settings|
            yielded_composer = child_composer
            yielded_settings = settings
          end
          expect(yielded_composer).to be_a(Composer)
          parent.each_child do |child|
            expect(yielded_composer.element).to eq(child)
          end
          expect(yielded_settings).to be_a(Settings::GridSettings)
        end

        context 'with an element expliclitly added to the child composer' do
          it 'does not add another child' do
            composer.add_grid('Child') do |child|
              child.add_text { 'explicit-content' }
              ['implicit-content']
            end
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextElement)
                expect(grand_child.content).to eq('explicit-content')
              end
            end
          end
        end

        context 'with nothing expliclitly added to the child composer' do
          it 'adds the text returned from the block as a TextElement to the child' do
            composer.add_grid('Child') { ['implicit-content'] }
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextElement)
                expect(grand_child.name).to eq('Child-Text-0')
                expect(grand_child.content).to eq('implicit-content')
              end
            end
          end
        end
      end
    end
  end
end
