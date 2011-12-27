module InvoicesHelper

  def can_change_this_state status, invoice, current_user
    if (invoice.ind_invoice_status_name.eql?("invoice.status.issued") || invoice.ind_invoice_status_name.eql?("invoice.status.paid")) && has_function(:name => "funct.invoice.status.override")
      return true
    end
    return has_function(:name => "funct.#{status.name}")
  end

end
