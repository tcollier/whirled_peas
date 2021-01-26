require 'whirled_peas/settings/border'
require 'whirled_peas/settings/color'
require 'whirled_peas/settings/container_settings'
require 'whirled_peas/settings/display_flow'

module WhirledPeas
  module Settings
    RSpec.shared_examples_for 'a ContainerSettings' do
      it_behaves_like 'an ElementSettings'

      context 'inherited attributes' do
        let(:parent) { ContainerSettings.new }

        it 'works with a parent that is an ElementSettings' do
          expect do
            described_class.inherit(ElementSettings.new)
          end.to_not raise_error
        end

        specify do
          parent.set_border(style: Border::Styles::SOFT, color: TextColor::GREEN)
          inherited = described_class.inherit(parent)
          expect(inherited.border.style).to eq(Border::Styles::SOFT)
          expect(inherited.border.color).to eq(TextColor::GREEN)
        end
      end

      context 'non-inherited attributes' do
        let(:parent) { ContainerSettings.new }

        specify do
          parent.align = Alignment::CENTER
          expect(described_class.inherit(parent).align).to eq(Alignment::DEFAULT)
        end

        specify do
          parent.set_border(left: true, top: true, inner_vert: true)
          inherited = described_class.inherit(parent)
          expect(inherited.border.left?).to eq(false)
          expect(inherited.border.top?).to eq(false)
          expect(inherited.border.inner_vert?).to eq(false)
        end

        specify do
          parent.flow = DisplayFlow::BOTTOM_TO_TOP
          expect(described_class.inherit(parent).flow).to eq(DisplayFlow::DEFAULT)
        end

        specify do
          parent.set_margin(left: 1, right: 2, top: 3, bottom: 4)
          inherited = described_class.inherit(parent)
          expect(inherited.margin.left).to eq(0)
          expect(inherited.margin.right).to eq(0)
          expect(inherited.margin.top).to eq(0)
          expect(inherited.margin.bottom).to eq(0)
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
          parent.width = 99
          expect(described_class.inherit(parent).width).to be_nil
        end
      end
    end
  end
end
