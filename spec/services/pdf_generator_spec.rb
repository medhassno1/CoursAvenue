require 'rails_helper'

describe PDFGenerator do
  describe '.generate_invoice' do
    let(:invoice)  { FactoryGirl.create(:subscriptions_invoice, :payed) }
    let(:template) { 'pro/subscriptions/invoices.pdf.haml' }

    before do
      allow_any_instance_of(AWS::S3::S3Object).to receive(:write).and_return(true)
    end

    it 'does nothing if the invoice or template are not defined' do
      expect(PDFGenerator.generate_invoice(nil, nil)).to be_nil
    end

    it 'generates the invoice as PDF' do
      locals    = invoice.send(:pdf_template_locals)
      generated = PDFGenerator.generate_invoice(invoice, template, locals)

      expect(generated).to be_truthy
    end
  end
end
