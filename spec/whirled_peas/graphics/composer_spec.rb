require 'whirled_peas/graphics/box_painter'
require 'whirled_peas/graphics/composer'
require 'whirled_peas/graphics/grid_painter'
require 'whirled_peas/graphics/text_painter'
require 'whirled_peas/settings/box_settings'
require 'whirled_peas/settings/grid_settings'
require 'whirled_peas/settings/text_settings'

module WhirledPeas
  module Graphics
    RSpec.describe Composer do
      describe '.stringable?' do
        specify { expect(described_class.stringable?(false)).to eq(true) }
        specify { expect(described_class.stringable?(true)).to eq(true) }
        specify { expect(described_class.stringable?(3.14)).to eq(true) }
        specify { expect(described_class.stringable?(42)).to eq(true) }
        specify { expect(described_class.stringable?(nil)).to eq(true) }
        specify { expect(described_class.stringable?('hi')).to eq(true) }
        specify { expect(described_class.stringable?(:hi)).to eq(true) }

        specify { expect(described_class.stringable?(Object.new)).to eq(false) }
      end

      describe '.next_name' do
        it 'returns a unique value each time' do
          names = Set.new
          100.times { names << described_class.next_name }
          expect(names.length).to eq(100)
        end
      end

      describe '#add_text' do
        subject(:composer) { described_class.new(parent) }

        let(:parent) { BoxPainter.new('Parent', parent_settings) }
        let(:parent_settings) { Settings::BoxSettings.new }

        it 'adds a TextPainter as the child of the composed painter' do
          composer.add_text('Child') { 'the-content' }
          expect(parent.num_children).to eq(1)
          parent.each_child do |child|
            expect(child).to be_a(TextPainter)
            expect(child.content).to eq(['the-content'])
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

        it 'converts a float to a string' do
          composer.add_text('Child') { 3.14 }
          expect(parent.num_children).to eq(1)
          parent.each_child do |child|
            expect(child.content).to eq(['3.14'])
          end
        end

        context 'when the value cannot be converted to a string' do
          it 'raises an ArgumentError' do
            expect do
              composer.add_text('Child') { Object.new }
            end.to raise_error(ArgumentError, 'Unsupported type for text: Object')
          end
        end
      end

      describe '#add_box' do
        subject(:composer) { described_class.new(parent) }

        let(:parent) { BoxPainter.new('Parent', parent_settings) }
        let(:parent_settings) { Settings::BoxSettings.new }

        it 'adds a BoxPainter as the child of the composed painter' do
          composer.add_box('Child') { 'the-content' }
          expect(parent.num_children).to eq(1)
          parent.each_child do |child|
            expect(child).to be_a(BoxPainter)
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
            expect(yielded_composer.painter).to eq(child)
          end
          expect(yielded_settings).to be_a(Settings::BoxSettings)
        end

        context 'with a painter expliclitly added to the child composer' do
          it 'does not add another child' do
            composer.add_box('Child') do |child|
              child.add_text { 'explicit-content' }
              'implicit-content'
            end
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextPainter)
                expect(grand_child.content).to eq(['explicit-content'])
              end
            end
          end
        end

        context 'with nothing expliclitly added to the child composer' do
          it 'adds the text returned from the block as a TextPainter to the child' do
            composer.add_box('Child') { 'implicit-content' }
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextPainter)
                expect(grand_child.name).to eq('Child-Text')
                expect(grand_child.content).to eq(['implicit-content'])
              end
            end
          end
        end
      end

      describe '#add_grid' do
        subject(:composer) { described_class.new(parent) }

        let(:parent) { GridPainter.new('Parent', parent_settings) }
        let(:parent_settings) { Settings::GridSettings.new }

        it 'adds a GridPainter as the child of the composed painter' do
          composer.add_grid('Child') { 'the-content' }
          expect(parent.num_children).to eq(1)
          parent.each_child do |child|
            expect(child).to be_a(GridPainter)
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
            expect(yielded_composer.painter).to eq(child)
          end
          expect(yielded_settings).to be_a(Settings::GridSettings)
        end

        context 'with a painter expliclitly added to the child composer' do
          it 'does not add another child' do
            composer.add_grid('Child') do |child|
              child.add_text { 'explicit-content' }
              ['implicit-content']
            end
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextPainter)
                expect(grand_child.content).to eq(['explicit-content'])
              end
            end
          end
        end

        context 'with nothing expliclitly added to the child composer' do
          it 'adds the text returned from the block as a TextPainter to the child' do
            composer.add_grid('Child') { ['implicit-content'] }
            parent.each_child do |child|
              expect(child.num_children).to eq(1)
              child.each_child do |grand_child|
                expect(grand_child).to be_a(TextPainter)
                expect(grand_child.name).to eq('Child-Text-0')
                expect(grand_child.content).to eq(['implicit-content'])
              end
            end
          end
        end
      end
    end
  end
end
