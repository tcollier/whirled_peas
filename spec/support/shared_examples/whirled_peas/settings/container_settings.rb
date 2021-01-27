require 'whirled_peas/settings/border'
require 'whirled_peas/settings/color'
require 'whirled_peas/settings/container_settings'
require 'whirled_peas/settings/display_flow'
require 'whirled_peas/settings/sizing'

module WhirledPeas
  module Settings
    RSpec.shared_examples_for 'a ContainerSettings' do
      it_behaves_like 'an ElementSettings'

      context 'validated attributes' do
        subject(:settings) { described_class.new }

        specify do
          expect { subject.align = :garbage }.to raise_error(ArgumentError, 'Unsupported alignment: :garbage')
        end

        specify do
          expect { subject.flow = :garbage }.to raise_error(ArgumentError, 'Unsupported display flow: :garbage')
        end

        specify do
          expect { subject.set_margin(left: 1, horiz: 1) }
            .to raise_error(ArgumentError, 'Cannot set horizontal margin when setting left/right')
        end

        specify do
          expect { subject.set_margin(right: 1, horiz: 1) }
            .to raise_error(ArgumentError, 'Cannot set horizontal margin when setting left/right')
        end

        specify do
          expect { subject.set_margin(top: 1, vert: 1) }
            .to raise_error(ArgumentError, 'Cannot set vertical margin when setting top/bottom')
        end

        specify do
          expect { subject.set_margin(bottom: 1, vert: 1) }
            .to raise_error(ArgumentError, 'Cannot set vertical margin when setting top/bottom')
        end

        specify do
          expect { subject.set_padding(left: 1, horiz: 1) }
            .to raise_error(ArgumentError, 'Cannot set horizontal padding when setting left/right')
        end

        specify do
          expect { subject.set_padding(right: 1, horiz: 1) }
            .to raise_error(ArgumentError, 'Cannot set horizontal padding when setting left/right')
        end

        specify do
          expect { subject.set_padding(top: 1, vert: 1) }
            .to raise_error(ArgumentError, 'Cannot set vertical padding when setting top/bottom')
        end

        specify do
          expect { subject.set_padding(bottom: 1, vert: 1) }
            .to raise_error(ArgumentError, 'Cannot set vertical padding when setting top/bottom')
        end
      end

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
          parent.sizing = :border
          expect(described_class.inherit(parent).sizing).to eq(Sizing::DEFAULT)
        end

        specify do
          parent.width = 99
          expect(described_class.inherit(parent).width).to be_nil
        end
      end
    end
  end
end
