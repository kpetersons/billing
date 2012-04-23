module InvoicesHelper

  def can_edit_invoice? status, invoice
    return invoice.invoice_status.editable_state || has_function(:name => "funct.invoice.status.override")
  end

  def can_change_this_state status, invoice
    if (invoice.ind_invoice_status_name.eql?("invoice.status.issued") ||
          invoice.ind_invoice_status_name.eql?("invoice.status.paid") ||
          invoice.ind_invoice_status_name.eql?("invoice.status.canceled"))
      if has_function(:name => "funct.invoice.status.override")
        return true
      else
        return false
      end
    end
    return has_function(:name => "funct.#{status.name}")
  end

  def can_print_it? invoice
    if invoice.status_name.eql?("invoice.status.approved") ||
        invoice.status_name.eql?("invoice.status.paid") ||
        invoice.status_name.eql?("invoice.status.awaiting") ||
        invoice.status_name.eql?("invoice.status.issued")
      return true
    end
    return false
  end

end
