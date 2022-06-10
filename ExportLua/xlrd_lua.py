import xlrd


def format_val(field_type, val):
    # todo 实现其他的比如说list转table
    if field_type == "string":
        return "'%s'" % val
    elif field_type == 'int':
        return int(val)
    else:
        return val


def save_to_file(path, contents):
    fh = open(path, 'w', encoding='utf-8')
    fh.write(contents)
    fh.close()


def parse_excel(file_path):
    workbook = xlrd.open_workbook(file_path)
    for i in range(workbook.nsheets):
        sheet = workbook.sheet_by_index(i)
        fields, describes, field_types, export_filter = {}, {}, {}, {}
        for col in range(sheet.ncols):
            fields[col] = sheet.cell_value(0, col)
            describes[col] = sheet.cell_value(1, col)
            field_types[col] = sheet.cell_value(2, col)
            export_filter[col] = sheet.cell_value(4, col)

        sb = "local %s = { \n" % sheet.name
        for row in range(sheet.nrows - 6):
            row += 6
            s = "\t[%s] = { \n" % format_val(field_types[0], sheet.cell_value(row, 0))
            for v in fields.items():
                # 过滤不需要的列，比如描述，或者服务器列客户端列
                if int(export_filter[v[0]]) != 0:
                    s += "\t\t['%s'] = %s, \n" % (v[1], format_val(field_types[v[0]], sheet.cell_value(row, v[0])))
            s += "\t},\n"
            sb += s

            print(s)
        sb += "}\n"

        # 写入字段描述
        describe = ""
        for v in fields.items():
            if int(export_filter[v[0]]) != 0:
                describe += "%s \t\t: %s \n" % (v[1], describes[v[0]])

        sb += "--[[\n%s --]]\n" % describe
        sb += "return %s" % sheet.name
        save_to_file(sheet.name + ".lua", sb)


if __name__ == "__main__":
    # 使用命令行参数
    file_name = "测试表格.xlsx"
    parse_excel(file_name)
