require 'whirled_peas/settings/border'
require 'whirled_peas/settings/color'
require 'whirled_peas/settings/container_settings'
require 'whirled_peas/settings/display_flow'

require_relative 'element_settings_spec'

module WhirledPeas
  module Settings
    RSpec.shared_examples_for 'a ContainerSettings' do
      it_behaves_like 'an ElementSettings'

      context 'casting' do
        let(:other) { ContainerSettings.new }

        it 'works with an other that is an ElementSettings' do
          expect do
            described_class.cast(ElementSettings.new)
          end.to_not raise_error
        end

        specify do
          other.set_margin(left: 1, right: 2, top: 3, bottom: 4)
          casted = described_class.cast(other)
          expect(casted.margin.left).to eq(1)
          expect(casted.margin.right).to eq(2)
          expect(casted.margin.top).to eq(3)
          expect(casted.margin.bottom).to eq(4)
        end

        specify do
          other.auto_margin = true
          expect(described_class.cast(other).auto_margin?).to eq(true)
        end

        specify do
          other.set_padding(left: 1, right: 2, top: 3, bottom: 4)
          casted = described_class.cast(other)
          expect(casted.padding.left).to eq(1)
          expect(casted.padding.right).to eq(2)
          expect(casted.padding.top).to eq(3)
          expect(casted.padding.bottom).to eq(4)
        end

        specify do
          other.set_border(inner_vert: true, style: BorderStyles::SOFT, color: TextColor::GREEN)
          casted = described_class.cast(other)
          expect(casted.border.inner_vert?).to eq(true)
          expect(casted.border.style).to eq(BorderStyles::SOFT)
          expect(casted.border.color).to eq(TextColor::GREEN)
        end

        specify do
          other.flow = DisplayFlow::BOTTOM_TO_TOP
          expect(described_class.cast(other).flow).to eq(DisplayFlow::BOTTOM_TO_TOP)
        end
      end

      context 'inherited settings' do
        let(:parent) { ContainerSettings.new }

        it 'works with a parent that is an ElementSettings' do
          expect do
            described_class.inherit(ElementSettings.new)
          end.to_not raise_error
        end

        specify do
          parent.set_border(style: BorderStyles::SOFT, color: TextColor::GREEN)
          inherited = described_class.inherit(parent)
          expect(inherited.border.style).to eq(BorderStyles::SOFT)
          expect(inherited.border.color).to eq(TextColor::GREEN)
        end

        specify do
          parent.flow = DisplayFlow::BOTTOM_TO_TOP
          expect(described_class.inherit(parent).flow).to eq(DisplayFlow::BOTTOM_TO_TOP)
        end
      end

      context 'non-inherited setting' do
        let(:parent) { ContainerSettings.new }

        specify do
          parent.set_margin(left: 1, right: 2, top: 3, bottom: 4)
          inherited = described_class.inherit(parent)
          expect(inherited.margin.left).to eq(0)
          expect(inherited.margin.right).to eq(0)
          expect(inherited.margin.top).to eq(0)
          expect(inherited.margin.bottom).to eq(0)
        end

        specify do
          parent.auto_margin = true
          expect(described_class.inherit(parent).auto_margin?).to eq(false)
        end

        specify do
          parent.set_padding(left: 1, right: 2, top: 3, bottom: 4)
          inherited = described_class.inherit(parent)
          expect(inherited.padding.left).to eq(0)
          expect(inherited.padding.right).to eq(0)
          expect(inherited.padding.top).to eq(0)
          expect(inherited.padding.bottom).to eq(0)
        end

        specify do
          parent.set_border(left: true, top: true, inner_vert: true)
          inherited = described_class.inherit(parent)
          expect(inherited.border.left?).to eq(false)
          expect(inherited.border.top?).to eq(false)
          expect(inherited.border.inner_vert?).to eq(false)
        end
      end
    end
  end
end
